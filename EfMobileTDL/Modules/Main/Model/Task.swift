//
//  Task.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import Foundation

struct Task: Equatable {
    let id: Int
    var title: String
    var subtitle: String
    let date: String
    var completed: Bool

    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }

    func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: date) ?? Date.distantPast
    }

    static func sortDataByDate() {
        data.sort { $0.getDate() > $1.getDate() }
    }

    static func changeTaskState(_ task: Task) {
        guard let index = data.firstIndex(where: { $0 == task }) else { print("Task not found"); return }
        data[index].completed.toggle()
    }

    static func editTask(_ newTask: Task, index: Int) {
//        print("Edited task \(newTask)")
        data[index] = newTask
    }

    static func addTask(_ newTask: Task) {
        data.append(newTask)
        sortDataByDate()
    }

    static func removeTask(_ task: Task) {
        data.removeAll { $0 == task }
    }

    static func getData() -> [Task] {
        sortDataByDate()
        return data
    }

    static var data: [Task] = [
        Task(id: 1, title: "Nice someone", subtitle: "Do something nice for someone you care about", date: "01/10/24", completed: true),
        Task(id: 2, title: "Memorize poem", subtitle: "Memorize a poem", date: "05/10/24", completed: false),
        Task(id: 3, title: "Watch classic", subtitle: "Watch a classic movie", date: "10/10/24", completed: true),
        Task(id: 4, title: "Watch documentary", subtitle: "Watch a documentary", date: "15/10/24", completed: true),
        Task(id: 5, title: "Invest cryptocurrency", subtitle: "Invest in cryptocurrency", date: "20/10/24", completed: false),
        Task(id: 6, title: "Contribute code", subtitle: "Contribute code or a monetary donation to an open-source software project", date: "25/10/24", completed: false),
        Task(id: 7, title: "Solve Rubik's", subtitle: "Solve a Rubik's cube", date: "30/10/24", completed: true),
        Task(id: 8, title: "Bake pastries", subtitle: "Bake pastries for yourself and neighbor", date: "05/11/24", completed: false),
        Task(id: 9, title: "Broadway production", subtitle: "Go see a Broadway production", date: "10/11/24", completed: true),
        Task(id: 10, title: "Thank letter", subtitle: "Write a thank you letter to an influential person in your life", date: "15/11/24", completed: false),
        Task(id: 11, title: "Invite friends", subtitle: "Invite some friends over for a game night", date: "20/11/24", completed: true),
        Task(id: 12, title: "Football scrimmage", subtitle: "Have a football scrimmage with some friends", date: "25/11/24", completed: false),
        Task(id: 13, title: "Text friend", subtitle: "Text a friend you haven't talked to in a long time", date: "30/11/24", completed: true),
        Task(id: 14, title: "Organize pantry", subtitle: "Organize pantry", date: "05/12/24", completed: true),
        Task(id: 15, title: "Buy decoration", subtitle: "Buy a new house decoration", date: "10/12/24", completed: false),
        Task(id: 16, title: "Plan vacation", subtitle: "Plan a vacation you've always wanted to take", date: "15/12/24", completed: true),
        Task(id: 17, title: "Clean car", subtitle: "Clean out car", date: "20/12/24", completed: false),
        Task(id: 18, title: "Draw Mandala", subtitle: "Draw and color a Mandala", date: "25/12/24", completed: true),
        Task(id: 19, title: "Create cookbook", subtitle: "Create a cookbook with favorite recipes", date: "30/12/24", completed: false),
        Task(id: 20, title: "Bake pie", subtitle: "Bake a pie with some friends", date: "05/01/25", completed: true),
        Task(id: 21, title: "Compost pile", subtitle: "Create a compost pile", date: "10/01/25", completed: false),
        Task(id: 22, title: "Take hike", subtitle: "Take a hike at a local park", date: "15/01/25", completed: true),
        Task(id: 23, title: "Take class", subtitle: "Take a class at local community center that interests you", date: "20/01/25", completed: false),
        Task(id: 24, title: "Research topic", subtitle: "Research a topic interested in", date: "25/01/25", completed: true),
        Task(id: 25, title: "Plan trip", subtitle: "Plan a trip to another country", date: "30/01/25", completed: false),
        Task(id: 26, title: "Improve typing", subtitle: "Improve touch typing", date: "05/02/25", completed: true),
        Task(id: 27, title: "Learn Express", subtitle: "Learn Express.js", date: "10/02/25", completed: false),
        Task(id: 28, title: "Learn calligraphy", subtitle: "Learn calligraphy", date: "15/02/25", completed: true),
        Task(id: 29, title: "Photo session", subtitle: "Have a photo session with some friends", date: "20/02/25", completed: false),
        Task(id: 30, title: "Go gym", subtitle: "Go to the gym", date: "03/03/25", completed: true)
    ]
}
