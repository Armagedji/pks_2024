package handlers

import (
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

		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
			return
		}

		// Создаем нового пользователя
		user := models.User{
			Email:    input.Email,
			Password: input.Password,
			Username: "", // username по умолчанию будет пустым
			ImageURL: "", // image по умолчанию будет пустым
			Phone:    "", // phone по умолчанию будет пустым
		}

		// Вставляем пользователя в базу данных
		_, err := db.Exec("INSERT INTO Users (email, password_hash, username, image, phone) VALUES ($1, $2, $3, $4, $5)",
			user.Email, user.Password, user.Username, user.ImageURL, user.Phone)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add user"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
	}
}
