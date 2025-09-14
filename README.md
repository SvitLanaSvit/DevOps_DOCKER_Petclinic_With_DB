## Запуск Spring Petclinic у Docker

1. **Створити мережу для проекту та бази даних:**
	> Створює окрему Docker-мережу, щоб контейнери могли "бачити" один одного по імені (наприклад, додаток і база даних).
	```bash
	docker network create petclinic_network
	```

2. **Створити і запустити контейнер для MySQL:**
	> Запускає контейнер з MySQL, створює базу даних, користувача та зберігає дані у volume. Контейнер буде доступний іншим контейнерам у мережі petclinic_network.
	```bash
	docker run -d --network petclinic_network --name mysql \
	  -e MYSQL_ROOT_PASSWORD=my_sql \
	  -e MYSQL_DATABASE=petclinic_db \
	  -e MYSQL_USER=sviti \
	  -e MYSQL_PASSWORD=capybara \
	  -p 3307:3306 -v mysql_data:/var/lib/mysql mysql:latest
	```

3. **Зібрати Docker image для проекту:**
	> Створює Docker-образ для Spring Petclinic із вашого коду. Його можна запускати як окремий контейнер.
	```bash
	docker build -t petclinic:v2 .
	```
	Щоб створити Docker image без запуску тестів, у Dockerfile використовується `ARG MVN_OPTIONS`. Для цього додаємо до команди:
		> Додає параметр для пропуску тестів під час білду (швидше створення образу).
	```bash
	docker build --build-arg MVN_OPTIONS="-DskipTests" -t petclinic:v2 .
	```

4. **Запустити проект у контейнері з підключенням до бази даних:**
	> Запускає Spring Petclinic у контейнері, підключаючи його до MySQL через мережу. Змінні середовища передаються для налаштування підключення до бази даних і вибору профілю.
	```bash
	docker run --rm -p 8080:8080 --network petclinic_network \
	  -e MYSQL_URL=jdbc:mysql://mysql/petclinic_db \
	  -e MYSQL_USER=sviti \
	  -e MYSQL_PASS=capybara \
	  -e SPRING_PROFILES_ACTIVE=mysql \
	  petclinic:v2
	```
	> `SPRING_PROFILES_ACTIVE` — це профіль, який відповідає файлу `application-mysql.properties`, де зберігаються налаштування для підключення до бази даних.
#
