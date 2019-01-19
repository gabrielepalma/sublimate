protocol FrozenModel {}
protocol OwnedFrozenModel : FrozenModel {}

class People : FrozenModel {
    var name : String
    var surname : String
    var email : String
    var age : Int
    var weight : Double
}

class Speeches : OwnedFrozenModel {
    var title : String
    var content : String
    var duration : Int
    var grade : Double
}
