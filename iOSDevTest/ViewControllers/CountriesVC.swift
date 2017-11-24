
import UIKit

class CountriesVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let countryDatasource = CountryDatasource()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        countryDatasource.loadFirstPage()
        tableView.reloadData()
        
        print("\(countryDatasource.count)")
        setRefreshControl()
    }
    
    func setRefreshControl() {
        refreshControl = UIRefreshControl.init()
        refreshControl.backgroundColor = UIColor.orange
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshContolReleased), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshContolReleased(){
        print("==== REFRESH ME!!!")
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                print("==== REFRESHED!!!")
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CountriesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell,
            let countryViewModel = countryDatasource.counryViewModelForRow(at:indexPath)
            else { return UITableViewCell() }
        
        cell.nameLabel.text = countryViewModel.name
        cell.capitalLabel.text = countryViewModel.capital
        cell.smallDescriptionLabel.text = countryViewModel.descriptionSmall
        
        if let imageUrl = countryViewModel.image {
            cell.flagImageView.pos_setImage(url: imageUrl)
        }
        return cell
    }
}
