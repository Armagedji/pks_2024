package models

type Product struct {
	ProductID         int     `db:"product_id" json:"product_id"`
	Name              string  `db:"name" json:"name"`
	Description       string  `db:"description" json:"description"`
	Short_description string  `db:"short_description" json:"short_description"`
	Price             float64 `db:"price" json:"price"`
	Stock             int     `db:"stock" json:"stock"`
	ImageURL          string  `db:"image" json:"image"`
	CreatedAt         string  `db:"created_at" json:"created_at"`
}
