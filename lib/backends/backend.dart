import "dart:math";

abstract class Backend {
    Backend({required this.data});

    Map<String, Map<String, dynamic>> data;
}

class TestBackend implements Backend {
    @override
    Map<String, Map<String, dynamic>> data;
    Random random = Random();

    List<String> categoriesList = ["audio", "video", "game", "development", "network", "graphics"];

    TestBackend() : data = {} {
       for (int i = 1; i <= 50; i++) {
            String appId = "app-$i";
            
            List<String> pickedCategories = _pickRandomCategories(categoriesList, 2, random);

            data[appId] = {
                "name": "App $i",
                "icon": "https://www.svgrepo.com/show/451998/application-x-executable.svg",  // Use the provided icon URL
                "description": "Description for App $i",
                "rating": 1 + random.nextDouble() * 4, // Random rating between 1 and 5
                "categories": pickedCategories,  // Randomly picked categories
                "installed": random.nextBool(),
                "verified": random.nextBool(),
                "featured": random.nextBool(),
                "reviews": [
                    {
                    "title": "Review for App $i",
                    "rating": random.nextInt(5) + 1,  // Random rating between 1 and 5 for review
                    "message": "This is a review message for App $i.",
                    }
                ],
            };
        } 
    }

    List<String> _pickRandomCategories(List<String> categoriesList, int count, Random random) {
        categoriesList.shuffle(random);
        return categoriesList.take(count).toList();
    }

}