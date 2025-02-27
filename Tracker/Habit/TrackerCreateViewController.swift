//
//  HabitCreateViewController.swift
//  Tracker
//
//  Created by Diliara Sadrieva on 10.02.2025.
//

import UIKit

protocol TrackerCreateViewControllerDelegate: AnyObject {
    func createButtonTap(_ tracker: Tracker, category: String)
    func editButtonTap(name: String, tracker: Tracker, category: String)
    func reloadData()
}
final class TrackerCreateViewController: UIViewController {
    weak var createHabitViewControllerDelegate: TrackerCreateViewControllerDelegate?
    private let analiticService = AnaliticService()
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    var isHabit: Bool = false
    var isEdit: Bool = false
    var tracker: Tracker?
    var completedDays: Int = 0
    private var selectedCategory: String = ""
    private var trackers: [Tracker] = []
    private var selectedDays: [WeekDay] = []
    private var colors = [#colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1), #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1),
                          #colorLiteral(red: 0.9840622544, green: 0.8660314083, blue: 0.8633159399, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1),
                          #colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1)]
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                          "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                          "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private var habitTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    private var editTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    private lazy var clearTextFieldButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(clearTextFieldButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.tintColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
        return button
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HabitTableCell.self, forCellReuseIdentifier: "HabitTableCell")
        tableView.layer.cornerRadius = 16
        
        return tableView
    }()
    private lazy var habitCollectionColorView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "habitCollectionColorView"
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HabitCollectionColorCell.self, forCellWithReuseIdentifier: "HabitCollectionColorCell")
        collectionView.register(HabitCollectionColorHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HabitCollectionColorHeaderCell")
        return collectionView
    }()
    private lazy var habitCollectionEmojiView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "habitCollectionEmojiView"
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate =  self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HabitCollectionEmojiCell.self, forCellWithReuseIdentifier: "HabitCollectionEmojiCell")
        collectionView.register(HabitCollectionEmojiHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HabitCollectionEmojiHeaderCell")
        return collectionView
    }()
    private var textFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = Colors.shared.dark
        return view
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("habitTextFieldPlaceholder", comment: "")
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(didChangeTF), for: .editingChanged)
        return textField
    }()
    private lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle(NSLocalizedString("habitCancelButton", comment: ""), for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle(NSLocalizedString("habitCreateButton", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
        button.layer.cornerRadius = 16
        return button
    }()
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        let title = NSLocalizedString("Save", comment: "")
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
        button.layer.cornerRadius = 16
        return button
    }()
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        setupViews()
        setupConstraints()
        createGesture()
        configureViews()
    }
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    @objc func didChangeTF() {
        guard let text = textField.text else { return }
        clearTextFieldButton.isHidden = text.isEmpty
        updateCreateButtonState()
    }
    @objc private func doneButtonTapped() {
        guard let trackerTitle = textField.text, !trackerTitle.isEmpty else {
            return
        }
        let days = isHabit ? self.selectedDays : WeekDay.allCases
        let object = Tracker(id: UUID(), name: trackerTitle, color: selectedColor ?? UIColor(), emoji: selectedEmoji ?? "", schedule: days, isPinned: false)
        TrackerStore.shared.addTracker(tracker: object, category: TrackerCategory(title: selectedCategory, trackers: []))
        TrackerStore.shared.log()
        createHabitViewControllerDelegate?.createButtonTap(object, category: selectedCategory)
        createHabitViewControllerDelegate?.reloadData()
        AnaliticService.report(event: "click", params: ["screen" : "TrackerCreate", "item" : "add_track"])
        dismiss()
    }
    @objc private func clearTextFieldButtonTapped() {
        textField.text = ""
        updateCreateButtonState()
        clearTextFieldButton.isHidden = true
    }
    @objc private func hideKeyboard() {
        textField.resignFirstResponder()
    }
    @objc private func editButtonTapped() {
        guard let trackerTitle = textField.text, !trackerTitle.isEmpty else {
            return
        }
        guard let editTracker = tracker,
        let color = selectedColor,
        let emoji = selectedEmoji else { return }
        let days = isHabit ? self.selectedDays : WeekDay.allCases
        let object = Tracker(id: UUID(), name: trackerTitle, color: color, emoji: emoji, schedule: days, isPinned: editTracker.isPinned)
        TrackerStore.shared.editTracker(name: editTracker.name, tracker: object, category: TrackerCategory(title: selectedCategory, trackers: []))
        createHabitViewControllerDelegate?.editButtonTap(name: editTracker.name, tracker: object, category: selectedCategory)
        createHabitViewControllerDelegate?.reloadData()
        dismiss()
    }
    private func updateCreateButtonState() {
        guard let text = textField.text else { return }
        if isHabit {
            if selectedDays.isEmpty || selectedEmoji == nil || text.isEmpty || selectedColor == nil || selectedCategory == "" {
                doneButton.isEnabled = false
                doneButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
                editButton.isEnabled = false
                editButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
            } else {
                doneButton.isEnabled = true
                editButton.isEnabled = true
                doneButton.backgroundColor = Colors.shared.createButton
                doneButton.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
                editButton.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
                editButton.backgroundColor = Colors.shared.createButton
            }
        } else {
            if selectedEmoji == nil ||
                text.isEmpty || selectedColor == nil || selectedCategory == "" {
                doneButton.isEnabled = false
                doneButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
                editButton.isEnabled = false
                editButton.backgroundColor = #colorLiteral(red: 0.7369984984, green: 0.7409694791, blue: 0.7575188279, alpha: 1)
                
            } else {
                doneButton.isEnabled = true
                editButton.isEnabled = true
                doneButton.backgroundColor = Colors.shared.createButton
                doneButton.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
                editButton.setTitleColor(Colors.shared.buttonTextColor, for: .normal)
                editButton.backgroundColor = Colors.shared.createButton
            }
        }
    }
    private func getCompletedCount(count: Int) -> String {
        let formatString: String = NSLocalizedString("completedDaysCount", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
    private func configureViews() {
        if isEdit {
            guard let editTracker = tracker else { return }
            let selectedWordDay = getCompletedCount(count: completedDays)
            habitTitleLabel.text = NSLocalizedString("Edit title", comment: "")
            editTitleLabel.text = "\(selectedWordDay)"
            textField.text = editTracker.name
            selectedDays = editTracker.schedule
            selectedColor = editTracker.color
            selectedEmoji = editTracker.emoji
            let desiredCategoryCoreData = TrackerCategoryStore.shared.fetchCategories()
            let desiredCategory = desiredCategoryCoreData.filter { category in
                category.trackers.contains { tracker in
                    tracker.name == editTracker.name
                }
            }
            
            selectedCategory = desiredCategory[0].title
            
            
        } else {
            habitTitleLabel.text = isHabit ? NSLocalizedString("habitTitle", comment: "") : NSLocalizedString("irregularEventTitle", comment: "")
        }
    }
    private func didSelectEmoji(_ emoji: String) {
        selectedEmoji = emoji
        updateCreateButtonState()
    }
    func didSelectColor(_ color: UIColor) {
        selectedColor = color
        updateCreateButtonState()
    }
    func didSelectCategory(_ category: String) {
        selectedCategory = category
        updateCreateButtonState()
    }
    func scheduleSelected(_ days: [WeekDay]) {
        selectedDays = days
        updateCreateButtonState()
    }
    private func createGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    private func setupConstraints() {
        if isEdit {
            NSLayoutConstraint.activate([
                editTitleLabel.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 24),
                editTitleLabel.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 16),
                editTitleLabel.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -16),
                textFieldView.topAnchor.constraint(equalTo: editTitleLabel.bottomAnchor, constant: 24)
            ])
        } else {
            textFieldView.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 24).isActive = true
        }
        if isHabit {
            NSLayoutConstraint.activate([
                tableView.heightAnchor.constraint(equalToConstant: 150)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.heightAnchor.constraint(equalToConstant: 75)
            ])
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitTitleLabel.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 30),
            habitTitleLabel.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 16),
            habitTitleLabel.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -16),
            scrollContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            textFieldView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 6),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -6),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: clearTextFieldButton.leadingAnchor, constant: -12),
            clearTextFieldButton.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -16),
            habitCollectionEmojiView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30),
            habitCollectionEmojiView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 18),
            habitCollectionEmojiView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -18),
            habitCollectionEmojiView.heightAnchor.constraint(equalToConstant: 205),
            habitCollectionColorView.topAnchor.constraint(equalTo: habitCollectionEmojiView.bottomAnchor, constant: 30),
            habitCollectionColorView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 18),
            habitCollectionColorView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -18),
            habitCollectionColorView.heightAnchor.constraint(equalToConstant: 204),
            habitCollectionColorView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func setupViews() {
        if isEdit {
            scrollView.addSubview(editTitleLabel)
            [cancelButton, editButton].forEach {
                buttonsStackView.addArrangedSubview($0)
            }
        } else {
            [cancelButton, doneButton].forEach {
                buttonsStackView.addArrangedSubview($0)
            }
        }
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(buttonsStackView)
        scrollView.addSubview(scrollContent)
        [habitTitleLabel, textFieldView, tableView, habitCollectionColorView, habitCollectionEmojiView].forEach {
            scrollContent.addSubview($0)
        }
        [textField, clearTextFieldButton].forEach {
            textFieldView.addSubview($0)
        }
    }
    private func dismiss() {
        view.window?.rootViewController?.dismiss(animated: true)
    }
}
extension TrackerCreateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHabit {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HabitTableCell") as? HabitTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if isHabit {
            if indexPath.row == 0 {
                cell.titleLabel.text = NSLocalizedString("tableCategoryTitle", comment: "")
                cell.descriptionLabel.text = selectedCategory
            } else {
                cell.titleLabel.text = NSLocalizedString("scheduleTitle", comment: "")
                let schedule = selectedDays.isEmpty ? "" : selectedDays.map { $0.shortTitle }.joined(separator: ", ")
                if selectedDays == WeekDay.allCases {
                    cell.descriptionLabel.text = NSLocalizedString("everyday", comment: "")
                } else {
                    cell.descriptionLabel.text = schedule
                }
            }
            return cell
        } else {
            cell.titleLabel.text = NSLocalizedString("tableCategoryTitle", comment: "")
            cell.descriptionLabel.text = selectedCategory
            return cell
        }
    }
}
extension TrackerCreateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController()
            categoryVC.delegate = self
            present(categoryVC, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        }
    }
}
extension TrackerCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension TrackerCreateViewController: ScheduleViewControllerDelegate {
    func didSelectScheduleDays(_ days: [WeekDay]) {
        scheduleSelected(days)
        tableView.reloadData()
    }
}
extension TrackerCreateViewController: CategoryViewControllerDelegate {
    func didSelectCategory(category: String) {
        didSelectCategory(category)
        tableView.reloadData()
    }
    func categoryRemoved() {
        selectedCategory = ""
        tableView.reloadData()
    }
}
extension TrackerCreateViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.accessibilityIdentifier == "habitCollectionColorView" ? "HabitCollectionColorCell" : "HabitCollectionEmojiCell", for: indexPath)
        
        if collectionView.accessibilityIdentifier == "habitCollectionColorView", let colorCell = cell as? HabitCollectionColorCell {
            colorCell.label.backgroundColor = colors[indexPath.row]
            if isEdit == true {
                if colors[indexPath.row] == selectedColor {
                    self.habitCollectionColorView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    colorCell.isSelected = true
                }
            }
            return cell
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView", let emojiCell = cell as? HabitCollectionEmojiCell {
            emojiCell.label.text = emojis[indexPath.row]
            if isEdit == true {
                if emojis[indexPath.row] == selectedEmoji {
                    self.habitCollectionEmojiView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    emojiCell.isSelected = true
                }
            }
            return cell
        } else {
            assertionFailure("No collection")
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewIdentifier: String
        let title: String
        
        switch collectionView.accessibilityIdentifier {
        case "habitCollectionColorView":
            viewIdentifier = "HabitCollectionColorHeaderCell"
            title = NSLocalizedString("colorHeader", comment: "")
        case "habitCollectionEmojiView":
            viewIdentifier = "HabitCollectionEmojiHeaderCell"
            title = NSLocalizedString("emojiHeader", comment: "")
        default:
            assertionFailure("No cells")
            return UICollectionReusableView()
        }
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewIdentifier, for: indexPath)
        
        if let colorHeaderCell = headerCell as? HabitCollectionColorHeaderCell {
            colorHeaderCell.title.text = title
            colorHeaderCell.title.textColor = UIColor.label
            return colorHeaderCell
        } else if let emojiHeaderCell = headerCell as? HabitCollectionEmojiHeaderCell {
            emojiHeaderCell.title.text = title
            emojiHeaderCell.title.textColor = UIColor.label
            return emojiHeaderCell
        } else {
            assertionFailure("Unable to cast supplementary view to expected type")
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == "habitCollectionColorView" {
            guard let colorCell = collectionView.cellForItem(at: indexPath) as? HabitCollectionColorCell else { return }
            guard let color = colorCell.label.backgroundColor else { return }
            didSelectColor(color)
            let borderColor = color.withAlphaComponent(0.3)
            colorCell.cellSelected(with: borderColor.cgColor)
            
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView" {
            guard let emojiCell = collectionView.cellForItem(at: indexPath) as? HabitCollectionEmojiCell else { return }
            guard let emoji = emojiCell.label.text else { return }
            didSelectEmoji(emoji)
            emojiCell.backgroundColor = #colorLiteral(red: 0.9212860465, green: 0.9279851317, blue: 0.9373531938, alpha: 1)
            emojiCell.layer.cornerRadius = 12
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == "habitCollectionColorView" {
            if let colorCell = collectionView.cellForItem(at: indexPath) as? HabitCollectionColorCell {
                didSelectColor(UIColor())
                colorCell.cellSelected(with: UIColor.clear.cgColor)
            } else {
                assertionFailure("Failed to cast cell to HabitCollectionColorCell")
            }
        } else if collectionView.accessibilityIdentifier == "habitCollectionEmojiView" {
            if let emojiCell = collectionView.cellForItem(at: indexPath) as? HabitCollectionEmojiCell {
                didSelectEmoji("")
                emojiCell.backgroundColor = .clear
                emojiCell.layer.cornerRadius = 12
            } else {
                assertionFailure("Failed to cast cell to HabitCollectionEmojiCell")
            }
        }
    }
}
extension TrackerCreateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
extension TrackerCreateViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view,
           view.isDescendant(of: habitCollectionColorView) ||
            view.isDescendant(of: tableView) ||
            view.isDescendant(of: habitCollectionEmojiView) {
            return false
        }
        return true
    }
}
