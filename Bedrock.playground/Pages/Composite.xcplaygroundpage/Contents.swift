/*:
 # Composite
 
 ## Intent
 - Composite lets clients treat individual objects and compositions of objects uniformly.
 - Recursive composition
 - "Directories contain entries, each of which could be a directory."
 
 This pattern lets you treat a collection of items the same as the individual items themselves.
 
 ![UML Diagram](Composite_UML.png)
 */

import Foundation

//: The easiest way to explain this pattern might be in conjunction with the command pattern

protocol Command {
    func execute()
}

//: Create a few command classes

class PrintCommand: Command {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func execute() {
        print(text)
    }
}

class SaveFileCommand: Command {
    func execute() {
        print("Saving file...")
    }
}

PrintCommand(text: "Hello World").execute()
SaveFileCommand().execute()

//: Now we can use the *Composite Pattern* to create a new *Command* called *MacroCommand*. MacroCommand looks like any other Command but it contains a collection of Commands to execute.

class MacroCommand: Command {
    let commands: [Command]?
    
    init(commands: [Command]?) {
        self.commands = commands
    }
    
    func execute() {
        commands?.forEach { $0.execute() }
    }
}

let macro = MacroCommand(commands: [PrintCommand(text: "About to save the file"), SaveFileCommand(), PrintCommand(text: "Done saving the file")])
macro.execute()
