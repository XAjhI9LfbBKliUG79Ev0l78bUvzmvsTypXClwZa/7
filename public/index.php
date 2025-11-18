<?php

require_once __DIR__ . '/../vendor/autoload.php';

use App\Article;
use App\Person;

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Article or Person</title>
    <style>
        body { font-family: sans-serif; }
        .container { max-width: 600px; margin: 2rem auto; padding: 2rem; border: 1px solid #ccc; border-radius: 5px; }
        .form-group { margin-bottom: 1rem; }
        label { display: block; margin-bottom: 0.5rem; }
        input[type="text"], input[type="email"], textarea { width: 100%; padding: 0.5rem; }
        button { padding: 0.75rem 1.5rem; cursor: pointer; }
        .result { margin-top: 2rem; padding: 1rem; border: 1px solid #eee; background-color: #f9f9f9; }
    </style>
</head>
<body>

<div class="container">
    <?php if (!isset($_POST['choice']) && !isset($_POST['create_article']) && !isset($_POST['create_person'])): ?>
        <form method="POST">
            <button type="submit" name="choice" value="article">Создать статью</button>
            <button type="submit" name="choice" value="person">Создать автора</button>
        </form>
    <?php endif; ?>

    <?php if (isset($_POST['choice']) && $_POST['choice'] === 'person'): ?>
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
    <?php endif; ?>

    <?php if (isset($_POST['choice']) && $_POST['choice'] === 'article'): ?>
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
    <?php endif; ?>

    <?php
    if (isset($_POST['create_article'])) {
        $article = new Article();
        $article->title = htmlspecialchars($_POST['title']);
        $article->author = htmlspecialchars($_POST['author']);
        $article->description = htmlspecialchars($_POST['description']);

        echo "<div class='result'>";
        echo "<h3>{$article->title}</h3>";
        echo "<p>{$article->description}</p>";
        echo "<p>Автор: {$article->author}</p>";
        echo "</div>";
    }

    if (isset($_POST['create_person'])) {
        $person = new Person();
        $person->first_name = htmlspecialchars($_POST['first_name']);
        $person->last_name = htmlspecialchars($_POST['last_name']);
        $person->email = htmlspecialchars($_POST['email']);

        echo "<div class='result'>";
        echo "<h3>{$person->last_name}</h3>";
        echo "<p>{$person->first_name}</p>";
        echo "<p>e-mail: {$person->email}</p>";
        echo "</div>";
    }
    ?>
</div>

</body>
</html>
