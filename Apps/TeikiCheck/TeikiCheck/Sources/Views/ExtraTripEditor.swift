import SwiftUI

/// 定期区間内の追加利用を 1 件編集するシート。
struct ExtraTripEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: ExtraTrip
    private let onSave: (ExtraTrip) -> Void

    init(trip: ExtraTrip, onSave: @escaping (ExtraTrip) -> Void) {
        _draft = State(initialValue: trip)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("用途（例：途中下車で買い物）", text: $draft.name)
                }

                Section("運賃") {
                    HStack {
                        Text("定期がなければの片道運賃")
                        Spacer()
                        TextField("0", value: $draft.oneWayFare, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 100)
                        Text("円").foregroundStyle(.secondary)
                    }
                    Toggle("往復する", isOn: $draft.isRoundTrip)
                }

                Section("頻度") {
                    Stepper("月に \(draft.timesPerMonth) 回", value: $draft.timesPerMonth, in: 1...100)
                }

                Section {
                    HStack {
                        Text("浮く運賃")
                        Spacer()
                        Text("+\(Theme.yen(draft.monthlyValue)) / 月")
                            .font(.headline)
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("追加利用")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        onSave(draft)
                        dismiss()
                    }
                    .disabled(draft.oneWayFare <= 0)
                }
            }
        }
    }
}
