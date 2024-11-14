from playwright.sync_api import sync_playwright
import re

def main():
    with sync_playwright() as p:
        # Открываем браузер
        browser = p.chromium.launch(headless=False)  # Поменять на True для фоново запуска
        page = browser.new_page()

        # Переходим на сайт
        page.goto("https://kad.arbitr.ru")

        # Клик на кнопку "Административные"
        page.locator("li.administrative").click()

        # Ожидание загрузки таблицы
        page.wait_for_selector("#b-cases")

        # Парсим строки таблицы
        rows = page.locator("#b-cases tbody tr")
        inn_list = []

        # Извлекаем данные по ИНН из первых 20 строк
        for i in range(min(20, rows.count())):
            row = rows.nth(i)
            inn_text = row.locator("td.respondent span.js-rolloverHtml").text_content()
            # Ищем ИНН с помощью регулярного выражения
            match = re.search(r"ИНН:\s*(\d+)", inn_text)
            if match:
                inn = match.group(1)
                inn_list.append(inn)

        # Выводим результат в консоль
        print("Найденные ИНН:")
        for inn in inn_list:
            print(inn)

        # Закрываем браузер
        browser.close()

if __name__ == "__main__":
    main()
