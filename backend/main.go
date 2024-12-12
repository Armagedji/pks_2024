package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

// Product представляет продукт
type Product struct {
	ID               int
	Title            string
	Image            string
	Description      string
	ShortDescription string
	Price            string

	IsFavorite bool
}

// Пример списка продуктов
var products = []Product{
	{
		ID:               1,
		Title:            "The Witcher 3: Wild Hunt",
		Image:            "https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/292030/header_russian.jpg?t=1730212926",
		Description:      "Эпическая RPG, где игроки исследуют огромный мир, сражаются с монстрами и решают моральные дилеммы.",
		ShortDescription: "Открытый мир, сражения с монстрами и напряженные сюжетные решения.",
		Price:            "1500",
		IsFavorite:       false,
	},
	{
		ID:               2,
		Title:            "Cyberpunk 2077",
		Image:            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHgJO0q8z6FRR2mzAPUYZLh9bEAu1sO7MF7A&s",
		Description:      "Шутер от первого лица в открытом мире с элементами RPG, действие происходит в мрачном будущем.",
		ShortDescription: "Мир будущего, уникальные технологии и захватывающие сюжетные линии.",
		Price:            "2500",
		IsFavorite:       false,
	},
	{
		ID:               3,
		Title:            "Red Dead Redemption 2",
		Image:            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeMmKiD9ge2VTy2CTf2VV05zq9dnrw-NQMdQ&s",
		Description:      "Дикий запад, открытый мир, потрясающая графика и захватывающий сюжет о ковбоях.",
		ShortDescription: "Жизнь на Диком Западе с приключениями и драмами.",
		Price:            "1700",
		IsFavorite:       false,
	},
	{
		ID:               4,
		Title:            "Minecraft",
		Image:            "https://assets.nintendo.com/image/upload/c_fill,w_1200/q_auto:best/f_auto/dpr_2.0/ncom/software/switch/70010000000964/a28a81253e919298beab2295e39a56b7a5140ef15abdb56135655e5c221b2a3a",
		Description:      "Песочница, позволяющая создавать и исследовать миры из блоков. Бесконечные возможности для творчества.",
		ShortDescription: "Построение и исследование блокового мира.",
		Price:            "800",
		IsFavorite:       false,
	},
	{
		ID:               5,
		Title:            "Horizon Zero Dawn",
		Image:            "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1151640/capsule_616x353.jpg?t=1729030787",
		Description:      "Приключенческая игра с открытым миром, где люди сражаются с роботами в постапокалиптическом будущем.",
		ShortDescription: "Будущее, в котором человечество борется с роботами.",
		Price:            "1900",
		IsFavorite:       false,
	},
	{
		ID:               6,
		Title:            "Grand Theft Auto V",
		Image:            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjOFIOP7gP0RTUbYogkHRXE1tOqhaTxCsGXA&s",
		Description:      "Игра с открытым миром, где игроки могут заниматься преступной деятельностью, участвовать в ограблениях и гонках.",
		ShortDescription: "Преступления, гонки и хаос в открытом мире.",
		Price:            "1200",
		IsFavorite:       false,
	},
	{
		ID:               7,
		Title:            "DOOM Eternal",
		Image:            "https://assets.xboxservices.com/assets/34/0a/340ada26-49f7-48f1-a572-b27dd6ec766b.jpg?n=DOOM-Eternal_GLP-Page-Hero-0_1083x609_02.jpg",
		Description:      "Шутер с быстрым темпом, где игрок сражается с демонами в аду и на Земле.",
		ShortDescription: "Сражения с демонами и динамичные боевые действия.",
		Price:            "1800",
		IsFavorite:       false,
	},
	{
		ID:               8,
		Title:            "Assassin's Creed Valhalla",
		Image:            "https://cdn.akamai.steamstatic.com/steam/apps/2208920/header.jpg?t=1697654233",
		Description:      "Экшн-RPG, основанная на эпохе викингов, с исследованиями, боевыми действиями и элементами стратегии.",
		ShortDescription: "Жизнь викинга, завоевания и исследования.",
		Price:            "2000",
		IsFavorite:       false,
	},
	{
		ID:               9,
		Title:            "Far Cry 5",
		Image:            "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/552520/capsule_616x353.jpg?t=1694554810",
		Description:      "Шутер с открытым миром, действие которого происходит в Америке, захваченной культом апокалипсиса.",
		ShortDescription: "Борьба с культом и спасение мира.",
		Price:            "1000",
		IsFavorite:       false,
	},
	{
		ID:               10,
		Title:            "Sekiro: Shadows Die Twice",
		Image:            "https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/814380/header.jpg?t=1726158438",
		Description:      "Экшн-игра с жесткими боями и элементами стелса, действие которой происходит в Японии эпохи самураев.",
		ShortDescription: "Сражения самураев и уникальный стиль боевых действий.",
		Price:            "2200",
		IsFavorite:       true,
	},
}

func getProductsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Printf("Sending all products\n")
	json.NewEncoder(w).Encode(products)
}

func createProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var newProduct Product
	err := json.NewDecoder(r.Body).Decode(&newProduct)
	if err != nil {
		fmt.Println("Error decoding request body:", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Printf("Received new Product: %+v\n", newProduct)

	newProduct.ID = len(products) + 1
	products = append(products, newProduct)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(newProduct)
}

func getProductByIDHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/Products/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	for _, Product := range products {
		if Product.ID == id {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(Product)
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func deleteProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/Products/delete/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	for i, Product := range products {
		if Product.ID == id {
			products = append(products[:i], products[i+1:]...)
			w.WriteHeader(http.StatusNoContent)
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func updateProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPut {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	idStr := r.URL.Path[len("/Products/update/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	var updatedProduct Product
	err = json.NewDecoder(r.Body).Decode(&updatedProduct)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	for i, Product := range products {
		if Product.ID == id {

			products[i].Image = updatedProduct.Image
			products[i].Title = updatedProduct.Title
			products[i].Description = updatedProduct.Description
			products[i].Price = updatedProduct.Price

			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(products[i])
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func main() {
	http.HandleFunc("/products", getProductsHandler)           // Получить все продукты
	http.HandleFunc("/products/create", createProductHandler)  // Создать продукт
	http.HandleFunc("/products/", getProductByIDHandler)       // Получить продукт по ID
	http.HandleFunc("/products/update/", updateProductHandler) // Обновить продукт
	http.HandleFunc("/products/delete/", deleteProductHandler) // Удалить продукт

	fmt.Println("Server is running on port 8080!")
	http.ListenAndServe(":8080", nil)
}
