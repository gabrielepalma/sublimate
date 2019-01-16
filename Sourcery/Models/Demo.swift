protocol FrozenModel {}
protocol OwnedFrozenModel : FrozenModel {}

class DemoAlpha : FrozenModel {
    var text : String
    var count : Int
}

class DemoBeta : OwnedFrozenModel {
    var name : String
    var surname : String
}
