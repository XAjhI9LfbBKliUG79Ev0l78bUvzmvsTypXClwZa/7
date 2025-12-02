<?php

namespace App\Controllers;

use App\Models\Article;

class ArticleController
{
    public function create()
    {
        $article = new Article();
        $article->title = htmlspecialchars($_POST['title']);
        $article->author = htmlspecialchars($_POST['author']);
        $article->description = htmlspecialchars($_POST['description']);
        return $article;
    }
}
