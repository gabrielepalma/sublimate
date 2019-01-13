protocol FrozenModel {}
protocol OwnedFrozenModel : FrozenModel {}

class DemoAlpha : FrozenModel {
@cellTitle
    var text : String
    var count : Int
}

class DemoBeta : OwnedFrozenModel {
@cellTitle
    var name : String
    var surname : String
}
