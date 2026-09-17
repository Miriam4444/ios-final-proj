//
//  MoleculeBuilderView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct MoleculeBuilderView: View {
    @State private var viewModel = MoleculeBuilderVM()
    @State private var periodicTableVM = PeriodicTableVM()
    @State private var showBondSidebar = false
    @State private var showAtomKeyboard = false
    @State private var showSaveDialog = false
    var savedMoleculesVM: SavedMoleculesVM
   
    let commonAtomSymbols = ["H", "He", "C", "N", "O"]
   
    var body: some View {
        NavigationView {
            ZStack {
                moleculeCanvas
               
                VStack {
                    Spacer()
                    HStack {
                        sidebarButtons
                        Spacer()
                    }
                }
            }
            .navigationTitle("Build Molecule")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        viewModel.clearWorkspace()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        showSaveDialog = true
                    }
                    .disabled(viewModel.placedAtoms.isEmpty)
                }
            }
            .sheet(isPresented: $showSaveDialog) {
                SaveMoleculePopUp(
                    moleculeName: $viewModel.currentMoleculeName,
                    onSave: {
                        let molecule = viewModel.createMolecule()
                        savedMoleculesVM.saveMolecule(molecule)
                        showSaveDialog = false
                    },
                    onCancel: {
                        showSaveDialog = false
                    }
                )
            }
            .task {
                await periodicTableVM.load()
            }
        }
    }
   
    var moleculeCanvas: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()
               
                ForEach(viewModel.bonds) { bond in
                    if let fromAtom = viewModel.placedAtoms.first(where: { $0.id == bond.fromAtomId }),
                       let toAtom = viewModel.placedAtoms.first(where: { $0.id == bond.toAtomId }) {
                        BondView(from: fromAtom.position, to: toAtom.position, bondType: bond.type)
                    }
                }
               
                ForEach(viewModel.placedAtoms) { placedAtom in
                    AtomView(
                        placedAtom: placedAtom,
                        isSelected: viewModel.selectedAtomForBonding?.id == placedAtom.id,
                        onTap: {
                            viewModel.chooseAtomForBonding(placedAtom)
                        },
                        onDelete: {
                            viewModel.deleteAtom(placedAtom)
                        },
                        onPositionChange: { newPosition in
                            viewModel.updateAtomPosition(placedAtom.id, to: newPosition)
                        }
                    )
                }
            }
        }
    }
   
    var sidebarButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showBondSidebar.toggle() }) {
                Image(systemName: "link")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
           
            Button(action: { showAtomKeyboard.toggle() }) {
                Image(systemName: "atom")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showBondSidebar) {
            BondSidebarView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAtomKeyboard) {
            AtomKeyboardView(
                commonAtomSymbols: commonAtomSymbols,
                allAtoms: periodicTableVM.elements,
                viewModel: viewModel
            )
        }
    }
}

struct AtomView: View {
    let placedAtom: PlacedAtom
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    let onPositionChange: (CGPoint) -> Void
   
    @State private var dragOffset: CGSize = .zero
   
    var body: some View {
        VStack(spacing: 2) {
            Text(placedAtom.atom.symbol)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(isSelected ? Color.orange : atomColor(for: placedAtom.atom.symbol))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
                )
        }
        .position(x: placedAtom.position.x + dragOffset.width,
                  y: placedAtom.position.y + dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    let newPosition = CGPoint(
                        x: placedAtom.position.x + value.translation.width,
                        y: placedAtom.position.y + value.translation.height
                    )
                    onPositionChange(newPosition)
                    dragOffset = .zero
                }
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    onTap()
                }
        )
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
   
    func atomColor(for symbol: String) -> Color {
        switch symbol {
        case "H": return Color.gray
        case "C": return Color.black
        case "N": return Color.blue
        case "O": return Color.red
        case "He": return Color.cyan
        default: return Color.purple
        }
    }
}

struct BondView: View {
    let from: CGPoint
    let to: CGPoint
    let bondType: BondType
   
    var body: some View {
        ZStack {
            // Draw the appropriate number of lines based on bond type
            ForEach(0..<numberOfLines, id: \.self) { index in
                Path { path in
                    let offset = calculateOffset(for: index)
                    path.move(to: CGPoint(x: from.x + offset.x, y: from.y + offset.y))
                    path.addLine(to: CGPoint(x: to.x + offset.x, y: to.y + offset.y))
                }
                .stroke(Color.black, lineWidth: 2)
            }
        }
    }
   
    private var numberOfLines: Int {
        switch bondType {
        case .single: return 1
        case .double: return 2
        case .triple: return 3
        }
    }
   
    //okay i was stumped here ngl because i needed to have the right number of bonds and they needed to be spaced right im sure theres a better way to do this but yeah i had to do some research on how to do this too and got the formula from online i hope thats okay
    private func calculateOffset(for index: Int) -> (x: CGFloat, y: CGFloat) {
        //if its a single bod we dont need to do any offset stuff
        guard numberOfLines > 1 else { return (0, 0) }
       
        let spacing: CGFloat = 3.5
        let dx = to.x - from.x
        let dy = to.y - from.y
        let length = sqrt(dx * dx + dy * dy)
       
        let perpX = -dy / length
        let perpY = dx / length
        let centerOffset = CGFloat(numberOfLines - 1) / 2.0
        let lineOffset = (CGFloat(index) - centerOffset) * spacing
       
        return (perpX * lineOffset, perpY * lineOffset)
    }
}
