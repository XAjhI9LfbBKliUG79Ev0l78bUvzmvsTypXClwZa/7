<form method="POST">
    <h2>Создать статью</h2>
    <div class="form-group">
        <label for="title">Заголовок (title)</label>
        <input type="text" id="title" name="title" required>
    </div>
    <div class="form-group">
        <label for="author">Автор (author)</label>
        <input type="text" id="author" name="author" required>
    </div>
    <div class="form-group">
        <label for="description">Описание (description)</label>
        <textarea id="description" name="description" required></textarea>
    </div>
    <button type="submit" name="create_article">Создать</button>
</form>
