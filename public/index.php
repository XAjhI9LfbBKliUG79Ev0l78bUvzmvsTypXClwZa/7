<?php

require_once __DIR__ . '/../vendor/autoload.php';

use App\Controllers\ArticleController;
use App\Controllers\PersonController;

include __DIR__ . '/../src/views/header.php';

if (isset($_POST['create_article'])) {
    $articleController = new ArticleController();
    $article = $articleController->create();
    include __DIR__ . '/../src/views/article_result.php';
} elseif (isset($_POST['create_person'])) {
    $personController = new PersonController();
    $person = $personController->create();
    include __DIR__ . '/../src/views/person_result.php';
} elseif (isset($_POST['choice'])) {
    if ($_POST['choice'] === 'article') {
        include __DIR__ . '/../src/views/article_form.php';
    } elseif ($_POST['choice'] === 'person') {
        include __DIR__ . '/../src/views/person_form.php';
    }
} else {
    include __DIR__ . '/../src/views/choice_form.php';
}

include __DIR__ . '/../src/views/footer.php';
