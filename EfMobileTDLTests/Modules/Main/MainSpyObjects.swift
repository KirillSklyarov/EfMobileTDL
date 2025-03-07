import XCTest
@testable import EfMobileTDL

// MARK: - View Spy

final class MainViewSpy: MainViewInput {
    var setupInitialStateCalled = false
    var loadingCalled = false
    var configureCalled = false
    var showErrorCalled = false
    var updateUICalled = false
    
    var lastDataReceived: [TDLItem]?
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    func loading() {
        loadingCalled = true
    }
    
    func configure(with data: [TDLItem]) {
        configureCalled = true
        lastDataReceived = data
    }
    
    func showError() {
        showErrorCalled = true
    }
    
    func updateUI(with data: [TDLItem]) {
        updateUICalled = true
        lastDataReceived = data
    }
}

// MARK: - Presenter Spy

final class MainPresenterSpy: MainViewOutput {
    var viewLoadedCalled = false
    var viewIsAppearingCalled = false
    var dataLoadedCalled = false
    var checkDataAndUpdateViewCalled = false
    var getErrorCalled = false
    var selectItemForEditingCalled = false
    var addNewTaskButtonTappedCalled = false
    var removeItemTappedCalled = false
    var changeItemStateCalled = false
    var filterDataCalled = false
    
    var lastDataLoaded: [TDLItem]?
    var lastItemForEditing: TDLItem?
    var lastItemToRemove: TDLItem?
    var lastItemToChangeState: TDLItem?
    var lastFilterQuery: String?
    
    func viewLoaded() {
        viewLoadedCalled = true
    }
    
    func viewIsAppearing() {
        viewIsAppearingCalled = true
    }
    
    func dataLoaded(_ data: [TDLItem]) {
        dataLoadedCalled = true
        lastDataLoaded = data
    }
    
    func checkDataAndUpdateView() {
        checkDataAndUpdateViewCalled = true
    }
    
    func getError() {
        getErrorCalled = true
    }
    
    func selectItemForEditing(_ item: TDLItem) {
        selectItemForEditingCalled = true
        lastItemForEditing = item
    }
    
    func addNewTaskButtonTapped() {
        addNewTaskButtonTappedCalled = true
    }
    
    func removeItemTapped(_ item: TDLItem) {
        removeItemTappedCalled = true
        lastItemToRemove = item
    }
    
    func changeItemState(_ item: TDLItem) {
        changeItemStateCalled = true
        lastItemToChangeState = item
    }
    
    func filterData(by query: String) {
        filterDataCalled = true
        lastFilterQuery = query
    }
}

// MARK: - Interactor Spy

final class MainInteractorSpy: MainInteractorInput {
    var getDataCalled = false
    var setUserTasksCalled = false
    var addTaskCalled = false
    var removeTaskCalled = false
    var updateTaskCalled = false
    var editTaskCalled = false
    var filterDataCalled = false
    var changeTaskStateCalled = false
    var getIndexCalled = false
    var fetchDataCalled = false
    var selectItemForEditingCalled = false
    var getNewDataFromCDCalled = false
    
    var lastTasksSet: [TDLItem]?
    var lastTaskAdded: TDLItem?
    var lastTaskRemoved: TDLItem?
    var lastTaskUpdated: TDLItem?
    var lastUpdateIndex: Int?
    var lastTaskEdited: TDLItem?
    var lastEditIndex: Int?
    var lastFilterString: String?
    var lastTaskStateChanged: TDLItem?
    var lastTaskForIndex: TDLItem?
    var lastItemForEditing: TDLItem?
    
    var dataToReturn: [TDLItem] = []
    var filteredDataToReturn: [TDLItem] = []
    var indexToReturn: Int? = 0
    var errorToThrow: Error?
    
    func getData(completion: @escaping ([TDLItem]) -> Void) {
        getDataCalled = true
        completion(dataToReturn)
    }
    
    func setUserTasks(_ tasks: [TDLItem]) {
        setUserTasksCalled = true
        lastTasksSet = tasks
    }
    
    func addTask(_ newTask: TDLItem) {
        addTaskCalled = true
        lastTaskAdded = newTask
    }
    
    func removeTask(_ task: TDLItem) {
        removeTaskCalled = true
        lastTaskRemoved = task
    }
    
    func updateTask(_ task: TDLItem, at index: Int) {
        updateTaskCalled = true
        lastTaskUpdated = task
        lastUpdateIndex = index
    }
    
    func editTask(_ newTask: TDLItem, index: Int) {
        editTaskCalled = true
        lastTaskEdited = newTask
        lastEditIndex = index
    }
    
    func filterData(by string: String) -> [TDLItem] {
        filterDataCalled = true
        lastFilterString = string
        return filteredDataToReturn
    }
    
    func changeTaskState(_ task: TDLItem) {
        changeTaskStateCalled = true
        lastTaskStateChanged = task
    }
    
    func getIndex(of task: TDLItem) -> Int? {
        getIndexCalled = true
        lastTaskForIndex = task
        return indexToReturn
    }
    
    func fetchData() async {
        fetchDataCalled = true
    }
    
    func selectItemForEditing(_ item: TDLItem) {
        selectItemForEditingCalled = true
        lastItemForEditing = item
    }
    
    func getNewDataFromCD() {
        getNewDataFromCDCalled = true
    }
}

// MARK: - Router Spy

final class MainRouterSpy: MainRouterProtocol {
    var navigationController: UINavigationController?
    var goToEditItemModuleCalled = false
    var goToAddItemModuleCalled = false
    
    func goToEditItemModule() {
        goToEditItemModuleCalled = true
    }
    
    func goToAddItemModule() {
        goToAddItemModuleCalled = true
    }
}

// MARK: - CoreDataManager Spy

final class CoreDataManagerSpy: CoreDataManagerProtocol {
    var getItemToEditCalled = false
    var setItemToEditCalled = false
    var updateItemCalled = false
    var addNewItemCalled = false
    var saveDataInCoreDataCalled = false
    var fetchDataCalled = false
    var removeItemCalled = false
    
    var lastItemToEdit: TDLItem?
    var lastItemUpdated: TDLItem?
    var lastItemAdded: TDLItem?
    var lastItemsToSave: [TDLItem]?
    var lastItemRemoved: TDLItem?
    
    var itemToEditToReturn: TDLItem?
    var dataToReturn: [TDL] = []
    var errorToThrow: Error?
    
    func getItemToEdit() -> TDLItem? {
        getItemToEditCalled = true
        return itemToEditToReturn
    }
    
    func setItemToEdit(_ item: TDLItem) {
        setItemToEditCalled = true
        lastItemToEdit = item
    }
    
    func updateItem(_ item: TDLItem) {
        updateItemCalled = true
        lastItemUpdated = item
    }
    
    func addNewItem(_ item: TDLItem) {
        addNewItemCalled = true
        lastItemAdded = item
    }
    
    func saveDataInCoreData(tdlItems: [TDLItem]) {
        saveDataInCoreDataCalled = true
        lastItemsToSave = tdlItems
    }
    
    func fetchData() -> [TDL] {
        fetchDataCalled = true
        return dataToReturn
    }
    
    func removeItem(_ item: TDLItem) {
        removeItemCalled = true
        lastItemRemoved = item
    }
}

// MARK: - Network Service Spy

final class NetworkServiceSpy: NetworkServiceProtocol {
    var fetchDataFromServerCalled = false
    var fetchDataFirstTimeCalled = false
    
    var dataToReturn: [TDLItem] = []
    var errorToThrow: Error?
    
    func fetchDataFromServer() async throws -> [TDLItem] {
        fetchDataFromServerCalled = true
        if let error = errorToThrow {
            throw error
        }
        return dataToReturn
    }
    
    func fetchDataFirstTime() async throws -> [TDLItem] {
        fetchDataFirstTimeCalled = true
        if let error = errorToThrow {
            throw error
        }
        return dataToReturn
    }
}

enum TestError: Error {
    case generic
}
