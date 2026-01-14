import SwiftyR2

@main
struct Main {
    static func main() async throws {
        let core = await R2Core.create()
        let output = await core.cmd("?E Hello World")
        print(output)
    }
}