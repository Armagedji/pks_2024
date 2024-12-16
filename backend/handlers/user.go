package handlers

import (
	"fmt"
	"net/http"
	"shopApi/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func GetUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		email := c.Param("email")

		var user models.User
		err := db.Get(&user, "SELECT * FROM Users WHERE LOWER(email) = LOWER($1)", email)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
			return
		}
		c.JSON(http.StatusOK, user)
	}
}

// Обработчик для добавления нового пользователя
func AddUser(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var input struct {
			Email    string `json:"email"`
			Password string `json:"password"`
		}

		// Логируем запрос
		fmt.Println("Received request to add user")

		// Привязка JSON
		if err := c.ShouldBindJSON(&input); err != nil {
			// Логируем ошибку при привязке данных
			fmt.Printf("Error binding JSON: %v\n", err)
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
			return
		}

		// Логируем полученные данные
		fmt.Printf("Received input: Email=%s, Password=%s\n", input.Email, input.Password)

		// Создаем нового пользователя
		user := models.User{
			Email:    input.Email,
			Password: input.Password,
			Username: "", // username по умолчанию будет пустым
			ImageURL: "", // image по умолчанию будет пустым
			Phone:    "", // phone по умолчанию будет пустым
		}

		// Логируем информацию о пользователе, который будет добавлен
		fmt.Printf("Creating user: %+v\n", user)

		// Вставляем пользователя в базу данных
		_, err := db.Exec("INSERT INTO Users (email, password_hash, username, image, phone) VALUES ($1, $2, $3, $4, $5)",
			user.Email, user.Password, user.Username, user.ImageURL, user.Phone)

		if err != nil {
			// Логируем ошибку при вставке в базу данных
			fmt.Printf("Error inserting user into database: %v\n", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to add user: %v", err)})
			return
		}

		// Логируем успешный ответ
		fmt.Println("User created successfully")

		c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
	}
}
