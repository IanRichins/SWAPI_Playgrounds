import Foundation


struct Person: Decodable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String
    let films: [URL]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String
    
}


struct Film: Decodable {
    
    let title: String
    let episode_id: Int
    let opening_crawl: String
    let director: String
    let producer: String
    let release_date: String
    let characters: [String]
    let planets: [String]
    let starships: [String]
    let vehicles: [String]
    let species: [String]
    let created: String
    let edited: String
    let url: String
    
}

class SwapiService {
    static let baseURL = URL(string: "https://swapi.dev/api/")
    static let apiEndPoint = "api"
    static let personItem = "people"
    static let filmItem = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = self.baseURL else { return completion(nil) }
        
        let peopleURL = baseURL.appendingPathComponent(personItem)
        
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        
        print("finalURl: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("URLSession error: \(error.localizedDescription)")
                return completion(nil)
                
            }
            guard let returnData = data else {return completion(nil)}
            
            do {
                let personDictionary = try JSONDecoder().decode(Person.self, from: returnData)
                return completion(personDictionary)
            } catch {
                print("decoding error: \(error.localizedDescription)")
            }
        } .resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        print("finalURl: \(url)")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("URLSession error: \(error.localizedDescription)")
                return completion(nil)
                
            }
            guard let returnData = data else {return completion(nil)}
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: returnData)
                return completion(film)
            } catch {
                print("decoding error: \(error.localizedDescription)")
            }
        } .resume()
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    guard let person = person else { return }
    print("Person: \(person)")
    
    for url in person.films {
        SwapiService.fetchFilm(url: url) { (film) in
            guard let film = film else { return }
            print("film: \(film)")
            
        }
    }
}

