//
//  Task.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import Foundation

struct Task: Equatable {
    var title: String
    var subtitle: String
    var date: String

    func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: date) ?? Date.distantPast
    }

    static func sortDataByDate() {
        data.sort { $0.getDate() > $1.getDate() }
    }

    static func editTask(_ newTask: Task, index: Int) {
//        print("Edited task \(newTask)")
        data[index] = newTask
    }

    static func addTask(_ newTask: Task) {
        data.append(newTask)
        sortDataByDate()
    }

    static func getData() -> [Task] {
        sortDataByDate()
        return data
    }

    static var data: [Task] = [
        Task(title: "Nice someone", subtitle: "Do something nice for someone you care about", date: "01/10/24"),
        Task(title: "Memorize poem", subtitle: "Memorize a poem", date: "05/10/24"),
        Task(title: "Watch classic", subtitle: "Watch a classic movie", date: "10/10/24"),
        Task(title: "Watch documentary", subtitle: "Watch a documentary", date: "15/10/24"),
        Task(title: "Invest cryptocurrency", subtitle: "Invest in cryptocurrency", date: "20/10/24"),
        Task(title: "Contribute code", subtitle: "Contribute code or a monetary donation to an open-source software project", date: "25/10/24"),
        Task(title: "Solve Rubik's", subtitle: "Solve a Rubik's cube", date: "30/10/24"),
        Task(title: "Bake pastries", subtitle: "Bake pastries for yourself and neighbor", date: "05/11/24"),
        Task(title: "Broadway production", subtitle: "Go see a Broadway production", date: "10/11/24"),
        Task(title: "Thank letter", subtitle: "Write a thank you letter to an influential person in your life", date: "15/11/24"),
        Task(title: "Invite friends", subtitle: "Invite some friends over for a game night", date: "20/11/24"),
        Task(title: "Football scrimmage", subtitle: "Have a football scrimmage with some friends", date: "25/11/24"),
        Task(title: "Text friend", subtitle: "Text a friend you haven't talked to in a long time", date: "30/11/24"),
        Task(title: "Organize pantry", subtitle: "Organize pantry", date: "05/12/24"),
        Task(title: "Buy decoration", subtitle: "Buy a new house decoration", date: "10/12/24"),
        Task(title: "Plan vacation", subtitle: "Plan a vacation you've always wanted to take", date: "15/12/24"),
        Task(title: "Clean car", subtitle: "Clean out car", date: "20/12/24"),
        Task(title: "Draw Mandala", subtitle: "Draw and color a Mandala", date: "25/12/24"),
        Task(title: "Create cookbook", subtitle: "Create a cookbook with favorite recipes", date: "30/12/24"),
        Task(title: "Bake pie", subtitle: "Bake a pie with some friends", date: "05/01/25"),
        Task(title: "Compost pile", subtitle: "Create a compost pile", date: "10/01/25"),
        Task(title: "Take hike", subtitle: "Take a hike at a local park", date: "15/01/25"),
        Task(title: "Take class", subtitle: "Take a class at local community center that interests you", date: "20/01/25"),
        Task(title: "Research topic", subtitle: "Research a topic interested in", date: "25/01/25"),
        Task(title: "Plan trip", subtitle: "Plan a trip to another country", date: "30/01/25"),
        Task(title: "Improve typing", subtitle: "Improve touch typing", date: "05/02/25"),
        Task(title: "Learn Express", subtitle: "Learn Express.js", date: "10/02/25"),
        Task(title: "Learn calligraphy", subtitle: "Learn calligraphy", date: "15/02/25"),
        Task(title: "Photo session", subtitle: "Have a photo session with some friends", date: "20/02/25"),
        Task(title: "Go gym", subtitle: "Go to the gym", date: "03/03/25")
    ]
}
