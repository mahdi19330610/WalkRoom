import SwiftUI
import SpriteKit

@main
struct WalkRoomApp: App {
    var body: some Scene {
        WindowGroup { GameView() }
    }
}

struct GameView: View {
    @State private var scene: GameScene = {
        let s = GameScene(size: CGSize(width: 400, height: 800))
        s.scaleMode = .resizeFill
        return s
    }()

    var body: some View {
        SpriteView(scene: scene).ignoresSafeArea()
    }
}
