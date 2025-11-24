<form method="POST">
    <h2>Создать автора</h2>
    <div class="form-group">
        <label for="first_name">Имя (first_name)</label>
        <input type="text" id="first_name" name="first_name" required>
    </div>
    <div class="form-group">
        <label for="last_name">Фамилия (last_name)</label>
        <input type="text" id="last_name" name="last_name" required>
    </div>
    <div class="form-group">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email" required>
    </div>
    <button type="submit" name="create_person">Создать</button>
</form>
