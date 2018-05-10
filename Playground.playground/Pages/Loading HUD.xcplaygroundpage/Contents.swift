import Dispatch
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class Foo {
    
    private var count: UInt = 0
    
    func show() {
        DispatchQueue.main.async {
            guard self.count == 0 else {
                self.count += 1
                print("Already Shown: ", self.count)
                return
            }
            self.count = 1
            print("Show: ", self.count)
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            guard self.count > 0 else { print("Nothing to do here"); return }
            guard self.count == 1 else {
                self.count -= 1
                print("Can't hide yet: ", self.count)
                return
            }
            self.count = 0
            print("Hide: ", self.count)
        }
    }
}

let foo = Foo()
foo.show()
foo.show()
foo.show()
foo.show()
foo.hide()
foo.hide()
foo.hide()
foo.hide()
foo.show()
foo.hide()
foo.hide()
foo.hide()


