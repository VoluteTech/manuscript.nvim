---
id: So many layers of abstraction...
aliases: []
tags: []
---

--- id: So many layers of abstraction... aliases: [] tags: [] ---

Over the years, developing tools and products has changed a lot in the web
development world. We have changed our tools, languages, concepts and
philosophies over time and I though it would be interesting to lean over this
topic. We are going to go through a pretty large timeline, from the early
beginning of web (2000s), going through the frameworks war and a bunch of other
things, until what we know today with AI.

### The MVC Revolution : Organizing the chaos

Back in the old days, web code was "spaghetti". You’d have PHP tags mixed with
HTML, which was mixed with inline CSS, which contained a SQL query. It was
pretty tough to maintain and we can safely say that the MVC model was a really
helpful thing at that time. It would abstract things to organize the code into
3 blocks :
- Model -> Abstraction of the database. You would stop writing SQL queries by
hand, and started calling things like `Users.all()`.
- View -> Abstraction of the UI. Templates meant you didn't have to `echo` HTML
strings.
- Controller -> Abstraction of the logic. The bridge that kept the data and the
UI from touching each other. It's in this era that is actually born the term
"Web developer". But it was not that popular yet. Design patterns started to be
a thing and we began to optimize the way of building web app instead of just
"making pages load".

### The SPA Revolution : The browser as an OS

Around 2011, we realized that re-rendering the entire page when a user clicked
a button was slow. That's when we invented the concept of Virtual DOM,
client-side rendering and Single Page Application. It's also at that time that
frameworks like Angular and React were born even though React. These
technologies actually introduced a massive layer between the developer and the
actual browser DOM.

Developers stop being "Document Creators" and became "Application Developers".
The complexity shifted from the server to the browser and suddenly, you needed
to build your application as a bundle with webpack just to run a `Hello World`.

We didn't know back then that the Javascript ecosystem would turn into such a
quagmire. ![[Pasted image 20260322183722.png]] ### The container era : Death of
"It works on my machine"

As applications and services grew up, the problem became the deployment. We all
know the phrase : "It works on my machine". That's when things like Docker came
in. If every devs in a team had a different version of node, python or a linux
library, you could create a Docker container so that everybody was on the same
page.

"Devops" became a thing even though nowadays, every developer should know a
substantial amount of devops to work in a team. We stopped installing software
on servers. Instead, we started "shipping the whole computer." And the
abstraction is now the hardware ; it became invisible. You were just moving
boxes around a global grid. ### The Serverless era : The vanishing backend

But recently, even "managing a container" started feeling like too much work.
Why should a developer care about CPU cores or memory allocation? Now with
things like AWS, Azure and Google Cloud platform, you hand over the entire
execution lifecycle to the cloud provider. Your whole infrastructure now
depends on an external actor.

We came to a point where we abstract entire logic blocks of our application.
You put the state of your app into external databases and S3 buckets. We also
now have a problem of "Black Box" debugging : When your code is slow, is it
your code? The database? Or is it a "Cold Start" in the provider's
infrastructure? You can't `ssh` into the server to check because the server
doesn't "exist." ### The AI layer : Abstracting the code

And of course, the final boss : AI, or rather LLMs. Or agentic coding. Or
prompt engineering. I don't know, I feel like there is a new thing every
tuesday. Now we abstracted one of the most important parts of being a
developer. Writing code (I didn't say good code).

Thanks to hype bros coming from the NFT trends, you can believe that you're a
software engineer by just prompting Claude code to build a to do list. I guess
that the bottleneck was the human's ability to write syntax. How could we build
good products without AI... ### The cost of abstraction

I think that this is interesting to take a step back to see and remember where
we came from, and to see where we are now. All these layers of abstraction have
been created for a reason (for the most part) : helping the human in his task.
But the problem is that the more you abstract things, the more control you
lose, and it becomes really hard to truly understand what's going on. The Leaky
Abstraction principle taught us that when things break today, they break in
ways that are incredibly hard to debug on large scales. Our day-to-day work,
now looks like an agglomerate of concepts, dependencies and libraries written
by other people, and abstractions. So much so that we tend to forget how things
work under the hood. Especially for the young and junior programmers. They have
the keys to the kingdom, but they may have never seen the foundation it’s built
on. I know this because I started my programming journey during the frameworks
war era. And I think that I didn't take the best learning path. Like why do I
need to learn React and Vuejs when I barely even know Javascript ? And what the
hell is Docker and containerization ?

All this to say, learn the basics and take your time folks. AI is not gonna
take your job, even if some people would want this to happen.
