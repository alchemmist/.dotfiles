from typing import Iterable
import os
import shutil
import yaml

# Путь к вашей базе знаний Obsidian
obsidian_notes_path = "/home/alchemmist/knowledge-base"

# Путь к папке блога
blog_path = "/home/alchemmist/code/blog/content"


def load_metadata(file_path) -> Iterable | None:
    with open(file_path, "r", encoding="utf-8") as f:
        # Чтение первых нескольких строк, чтобы проверить метаинформацию
        try:
            content = f.read()
            # Проверяем, есть ли метаинформация в формате YAML в начале файла
            if content.startswith("---"):
                yaml_content = content.split("---")[1]  # Разделяем метаинформацию
                metadata = yaml.safe_load(yaml_content)
                # Проверяем наличие тега #public в метаданных
                return metadata
        except yaml.YAMLError as e:
            # print(f"==> Ошибка при обработке YAML в файле {file_path}: {e}")
            ...


# Функция для проверки, содержит ли заметка тег #public в YAML метаинформации
def has_public_tag(file_path) -> bool | None:
    metadata = load_metadata(file_path)
    if not metadata:
        return None
    return "taxonomies" in metadata


# Функция для копирования заметок в папку блога
def copy_notes_to_blog():
    # Пробегаем по всем файлам в папке Obsidian
    for root, dirs, files in os.walk(obsidian_notes_path):
        for file in files:
            # Ожидаем, что заметки будут в формате markdown (.md)
            if file.endswith(".md"):
                file_path = os.path.join(root, file)

                # Проверяем, имеет ли заметка тег #public
                if has_public_tag(file_path):
                    print(f"Переносим заметку: {file}")
                    # Путь к новой заметке в блоге
                    blog_file_path = os.path.join(blog_path, file)

                    # Если такая заметка уже существует, заменяем её
                    if os.path.exists(blog_file_path):
                        print(f"==> Заметка {file} уже существует. Перезаписываем.")
                        os.remove(blog_file_path)

                    # Копируем файл в папку блога
                    shutil.copy(file_path, blog_file_path)
                    print(f"==> Заметка {file} перенесена в блог.")


# Запуск процесса копирования
if __name__ == "__main__":
    copy_notes_to_blog()
