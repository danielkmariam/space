<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class HelloController extends AbstractController
{
    /**
     * @Route("/", name="hello")
     */
    public function index(): Response
    {
        return new Response(
            '<html><body><h1>Hello world from symfony 5.3 deployed in Azure Cluster</h1></body></html>'
        );
    }
}
