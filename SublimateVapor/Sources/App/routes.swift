import Vapor
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let password = User.sublimatePasswordAuthMiddleware(using: BCryptDigest())
    let refresh = User.sublimateRefreshJwtAuthMiddleware(signers: SublimateJwt.signers)
    let access = PublicUser.sublimateBearerAuthMiddleware(signers: SublimateJwt.signers)

    let authenticationGroup = router.grouped([password, refresh])
    let accessGroup = router.grouped(access)

    let userController = UserController()
    router.post("createUser", use: userController.createUser)
    authenticationGroup.post("token", use: userController.loginUser)
    authenticationGroup.post("logout", use: userController.logout)

    let debug = Debug()
    router.get("tokens", use: debug.listTokens)
    router.get("users", use: debug.listUsers)

    configureSublimateRoutes(plain: router, resourceGroup: accessGroup)
}

class Debug {

    /// Returns the list
    func listTokens(_ req: Request) throws -> Future<[RefreshToken]> {
        return RefreshToken.query(on: req).all()
    }

    /// Returns the list
    func listUsers(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }


}
