final class ObservableObject<T> {
    
    var resourceArr: [T] {
        didSet {
            listener?(resourceArr)
        }
    }
    
    private var listener: (([T]) -> Void)?
    
    init(resourceArr: [T]) {
        self.resourceArr = resourceArr
    }
    
    func binder(listener: @escaping ([T]) -> Void) {
        self.listener = listener
    }
    
    func notify() {
        listener?(resourceArr)
    }
}
