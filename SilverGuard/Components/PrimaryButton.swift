import SwiftUI

// MARK: - Primary Action Button
struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }
            }
            action()
        }) {
            HStack(spacing: 10) {
                Text(title)
                    .font(SilverGuardTypography.labelAction)
                    .foregroundColor(.white)
                if let img = systemImage {
                    Image(systemName: img)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                    .fill(Color.silverPrimaryContainer)
                    .overlay(
                        RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                            .fill(Color.black.opacity(isPressed ? 0.12 : 0))
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .shadow(color: Color.silverPrimaryContainer.opacity(isPressed ? 0.08 : 0.2),
                    radius: isPressed ? 2 : 6, x: 0, y: isPressed ? 1 : 3)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
    }
}

// MARK: - Secondary / Outline Button
struct SecondaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }
            }
            action()
        }) {
            HStack(spacing: 10) {
                if let img = systemImage {
                    Image(systemName: img)
                        .font(.system(size: 20, weight: .semibold))
                }
                Text(title)
                    .font(SilverGuardTypography.labelAction)
            }
            .foregroundColor(Color.silverPrimaryContainer)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                    .fill(Color.silverSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                            .stroke(Color.silverPrimaryContainer, lineWidth: 2)
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
    }
}

// MARK: - Destructive Button
struct DestructiveButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.1)) { isPressed = false }
            }
            action()
        }) {
            HStack(spacing: 10) {
                if let img = systemImage {
                    Image(systemName: img)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(SilverGuardTypography.labelAction)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                    .fill(Color.silverDanger)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
    }
}

// MARK: - Preview
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            PrimaryButton(title: "Start Practice", systemImage: "arrow.right") {}
            SecondaryButton(title: "Practice Again", systemImage: "arrow.clockwise") {}
            DestructiveButton(title: "Hang Up", systemImage: "phone.down.fill") {}
        }
        .padding()
        .background(Color.silverBackground)
    }
}
