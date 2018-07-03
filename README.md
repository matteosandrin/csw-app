# The Cambridge School of Weston App

<figure>
	<p align="center">
  		<img src="https://github.com/matteosandrin/csw-app/raw/master/images/img03.png" style="width:30%">
  		<figcaption style="text-align:center"><i>First mockup of the CSW App.</i></figcaption>
  	<p/>
</figure>

### 1. The Idea

I remember very well the day I started mulling over the idea of building the Cambridge School of Weston App. The original plan was to publish a much simpler mapping app, which would show a satellite view of the school and some points of interest, which is easy enough to implement and shove in the *code-I-will-never-look-at-again* drawer. Instead, that day I discovered that MyCSW, the backend I was going to get the school's data from, had a very interesting but undocumented private API. I discovered that the MyCSW portal, essentially like an app itself, downloads an enormous amount of Javascript at login, and then requests all the data it needs through asynchronous AJAX requests, providing me with some handy endpoints from which I can access the information itself.

Besides the sheer thrill of the technical challenge, the very motivation behind the CSW App was the wave of discontent that I saw among my peers. Students hated having to login every time, just to check the lunch menu, and having to deal with the slow, painful load times of a website on mobile. I really felt like my work could make the lives of CSW students a tiny bit better. As a programmer I believe it's my duty to optimise, so I answered my calling.

However, a significant number of people were skeptical of the feasibility of this project, seeing how two other people had tried and failed before me to make even a minimum viable product. I considered these early failures my starting point, and tried to see how far they had gone.

### 2. The Early Prototype

Confident in my abilities, I set out to mockup how the app was going to look. Being a programmer by heart and designer by necessity, my design was not very elaborate, and instead remained bare-bones and strictly functional.

<figure>
	<p align="center">
	  <img src="https://github.com/matteosandrin/csw-app/raw/master/images/img01.png" style="width:50%">
	  <figcaption style="text-align:center"><i>First mockup of the CSW App.</i></figcaption>
	</p>
</figure>

I decided from the very beginning that the first release of the App would be limited to three well defined functionalities: scheduling, homework and directories. I intentionally limited myself at first, because I knew that, if I was to achieve any kind of traction in the student body, the App needed to work, to work well, and to work better than the current solution.

### 3. The Discovery of Data

After having my proposal approved, I set out on a quest to reverse engineer the MyCSW backend. The first step on was to figure out how the system authenticated with the user. I used a great tool which most of you don't realise you have. By hitting `command + option + i` in Chrome, a panel opens up that lets anyone poke at the insides of the pages you surf every day. With this tool, I discovered that every time you log in, a request is sent to `https://csw.myschoolapp.com/api/SignIn` with your username and password as POST data. If the system validates your credentials, it sends back a special combination of information which, if sent along with all your other requests, gives you access to the person's information on MyCSW. For example, if I try to access `https://csw.myschoolapp.com/api/schedule/MyDayCalendarStudentList/` alone, I get back an error, but if I couple it with that combination of parameters, the system can verify I am actually who I say I am, and it gives me access to the information. Although this sounds fairly straightforward, it was a huge milestone for me.  
After the first one, the process to discover each subsequent endpoint was very similar: a combination of poking around, trying different parameters, until I reached the desired result. I ended up with a pretty comprehensive list, which now includes eighteen thoroughly documented endpoints.

### 4. The Interface

The process of designing an interface is crucial and often overlooked. Having an approachable and cohesive design was the only way to convince my users that my product was actually useful. The final design is very close to the early mockups, after hours of fighting with the interface editor. I managed to deliver a usable and arguably pleasing interface, on which anyone has yet to complain.  

<figure>
	<p align="center">
	  <img src="https://github.com/matteosandrin/csw-app/raw/master/images/img02.png" style="width:50%">
	  <figcaption style="text-align:center"><i>Final design of the CSW App.</i></figcaption>
	<p>
</figure>

### 5. The Programming

I started developing the codebase for the CSW App with a huge amount of momentum; the first week I was working on it during the day, during the night, during class, during lunch. I was a machine. However, after a few weeks, I realised that the codebase was beginning to look quite large, and it was a bit dangerous to keep all of its structure in my head. I started writing a technical record of how all the internals of the app work, what each file does, where it is supposed to be.  
After the first month, development started slowing down, I felt unmotivated. Every time I added one feature, two others seemed to break, and I knew I needed to do something to get my sprits back up, so I showed it to a few people. It seems like a simple thing to do, even insignificant, but seeing how living, breathing users interacted with my App and even congratulated me on it made a huge difference. I felt like my work was useful to the community, and this gave me a huge boost in confidence. After picking up some speed, I finished the version `1.0` a month after that, and I started the process of getting it approved by the AppStore. It took roughly two weeks to get the App through the gates of the AppStore, so I braced for the worst as the presentation date approached. For some undecipherable reason, the App got approved by Apple in a mere two days, just in time for my presentation.

### 6. The Presentation

I wrote most of my presentation slides the weekend before, which I then proceeded to present to an audience of three hundred people. The event had two main purposes: first and foremost, to foster the excitement of the community around my product, and second to promote a school-wide fundraising to pay for the \$99 publishing fees imposed by Apple. The second part was a bit of a gamble for me, because, to have the App ready at launch, I had paid the fee myself trusting the community to love enough my presentation to fund it.  
The presentation was a smashing success. Talking into the microphone with the spotlights shining into my eyes, a stylish looking deck of slides behind me, I felt like a young tech mogul presenting his version of the future to the world. The key part was one slide, towards the end, that boldly conveyed that the App was going to be free for everyone. The word "FREE" was written in gigantic letters and spanned across the whole screen, sliding in from the top like a giant. When I heard the cheering from the audience, the loudest I had ever heard, I knew the funding wouldn't be a problem.  
I placed a small, rectangular ballot box in the middle of the stage and, by the time the presentation was over, I had reached 70% of my funding goal. By the end of the next day, I was at \$342, and that's when I stopped accepting donations.

### 7. Conclusion

This project was a rollercoaster of emotions. I loved it and hated it at times, but I learned what it means to write a real, commercial app. Event though the profit I made is negligible, what makes it commercial nonetheless is the fact that lots of users rely on it to throughout their daily lives. All my previous projects were very self contained, but in this one I had to interact with my users, respond to their needs, answer their questions, resolve their complaints. It was immensely satisfying to see my product when casually glancing on random people's screens, even students I didn't actually know. I feel that I have made a small but tangible mark in the lives of CSW students, and that is worth all my effort.



