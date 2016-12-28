+++
date = "2016-12-28T12:45:38+01:00"
title = "One way to deploy your blog"
description = "Continuous deployment has been made easy nowadays. How about make it harder ?"
topics = []
tags = ['docker', 'github', 'faya', 'hypso']

+++

> **Note** : This post is really not about deploying your stuff the perfect way. It only presents how I deploy this blog.

### Too easy, ain't funny

I decided to create this blog months ago. Why the hell did it take so long you will ask ? 
Create a repo on GitHub, generate your static files with Hugo (or your favorite one), leverage GitHub pages and you're all set !

Well that's true but it seemed too easy from my point of view. Where is the fun in that ? Where do I learn something ?

So here was the objective :

* Host the blog files on GitHub
* Every single push should trigger a deployment

What I didn't want :

* Use cron
* Poll GitHub repo every minutes to listen for changes
* Use Jenkins or equivalent
* Use cron

In short, I wanted to be in push mode instead of pull mode.

With that in mind, I came up with a solution (which was already described in [some blog posts](https://nathanleclaire.com/blog/2014/08/17/automagical-deploys-from-docker-hub/))
involving Docker Hub automated builds and webhooks. In a nutshell : 

1. A push to the GitHub repo triggers the Docker Hub build
2. Once the build is done, Docker Hub send a request to a custom webhook
3. A simple web server of your own receives the request and redeploy your stuff

### Wait, is that all ?

Indeed you can set it up in about a day or two, so that's not what has taken me so long.

The thing is, you want to protect your simple web server (the Docker Hub webhook target) a bit otherwise everybody could redeploy again and again just by knowing the endpoint.
This could be done easily by defining a token which Docker Hub should send to the webhook endpoint. All the web server has to do is checking the given token and redeploy only if the token is alright.

At this point, I looked for some kind of simple "token manager" since I didn't want to just set a token in a config file or whatever (too easy you know) and unfortunately I didn't find any. You see me coming, right ? Yes, I spend months writing a token manager just to deploy a blog (of course with languages and frameworks I didn't know at all, I'll probably explain all this in an upcoming post).

### What does it look like in the end ?

Here are the required steps to make it work :

* Set up a [Faya](https://github.com/tzoratto/faya) instance (the token manager)
* Create a Dockerfile for your blog
* Host your blog on GitHub
* Configure automated build on Docker Hub
* Set up an [Hypso](https://github.com/tzoratto/hypso) instance (the tiny web server that will redeploy your blog)
* Configure a webhook on Docker Hub to send a request to your Hypso instance with a valid Faya token

And then you're done, every push on your blog repo will be automatically deployed.

![drawing](/deploy-your-blog-drawing.png)

