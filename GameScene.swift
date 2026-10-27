import SpriteKit

class GameScene: SKScene {
    private let player = SKShapeNode(circleOfRadius: 20)
    private let playerRadius: CGFloat = 20
    private var room = CGRect.zero
    private var target: CGPoint?
    private var lastTime: TimeInterval = 0
    private let walkSpeed: CGFloat = 250

    override func didMove(to view: SKView) {
        backgroundColor = .black
        buildRoom()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        buildRoom()
    }

    private func buildRoom() {
        guard size.width > 100, size.height > 200 else { return }
        removeAllChildren()

        // Floor + walls
        room = CGRect(x: 30, y: 90, width: size.width - 60, height: size.height - 180)
        let floor = SKShapeNode(rect: room)
        floor.fillColor = SKColor(red: 0.55, green: 0.38, blue: 0.22, alpha: 1)
        floor.strokeColor = SKColor(white: 0.85, alpha: 1)
        floor.lineWidth = 12
        addChild(floor)

        // Rug
        let rug = SKShapeNode(ellipseOf: CGSize(width: room.width * 0.6, height: 120))
        rug.position = CGPoint(x: room.midX, y: room.midY - 60)
        rug.fillColor = SKColor(red: 0.6, green: 0.15, blue: 0.2, alpha: 1)
        rug.strokeColor = .clear
        addChild(rug)

        // Table
        let table = SKShapeNode(rectOf: CGSize(width: 90, height: 55), cornerRadius: 6)
        table.position = CGPoint(x: room.midX, y: room.maxY - 80)
        table.fillColor = SKColor(red: 0.35, green: 0.22, blue: 0.1, alpha: 1)
        table.strokeColor = .black
        addChild(table)

        // Hint text
        let label = SKLabelNode(text: "Tap or drag to walk")
        label.fontSize = 18
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: 45)
        addChild(label)

        // Player
        player.fillColor = .cyan
        player.strokeColor = .white
        player.lineWidth = 3
        player.position = CGPoint(x: room.midX, y: room.midY)
        player.zPosition = 10
        addChild(player)
        target = nil
    }

    private func clampToRoom(_ p: CGPoint) -> CGPoint {
        let r = playerRadius + 6
        return CGPoint(x: min(max(p.x, room.minX + r), room.maxX - r),
                       y: min(max(p.y, room.minY + r), room.maxY - r))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { target = clampToRoom(t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { target = clampToRoom(t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
        let dt = lastTime == 0 ? 0 : min(currentTime - lastTime, 0.1)
        lastTime = currentTime
        guard let t = target else { return }

        let dx = t.x - player.position.x
        let dy = t.y - player.position.y
        let dist = hypot(dx, dy)
        let step = walkSpeed * CGFloat(dt)

        if dist <= step {
            player.position = t
            target = nil
        } else {
            player.position.x += dx / dist * step
            player.position.y += dy / dist * step
        }
    }
}
