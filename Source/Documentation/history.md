# History of TriangleDraw

Greetings from Simon Strandgaard. I'm the developer of TriangleDraw. It has been my hobby project for many years.

The story begin around year 2004, when I learn about a new visual programming language with the unorthodox name: [.werkkzeug](https://www.pouet.net/prod.php?which=12511),
by the german demo group [Farbrausch](https://en.wikipedia.org/wiki/Farbrausch). 
A powerful tool for composing digital art, a demotool.
With this approach it's possible to combine building blocks together in a few minutes, and see results immediately.
Accomplishing the same, would otherwise take days of coding and without any realtime feedback.
I was in love.

I developed my own visual programming language for macOS, named GraphicDesignerToolbox (aka. GDT), that had building blocks 
that could be stacked the same way as in .werkkzeug. For GDT I made several building blocks for manipulating bitmap images and a few building blocks for manipulating vector paths.
Around 2006, I made an "Align" building block for aligning any vector path to a grid system, such as triangular and square.
I used C++ for the building blocks and ObjectiveC for the UI. I learned that undo is incredibly difficult to deal with.

BOOM the iPad arrives around 2010, featuring a big touch screen. I developed the first version of TriangleDraw, that was
inspired by the "Align" building block from GDT. I soon after released TriangleDraw version 1. It had a tiny tiny canvas.
It only worked on iPad. No support for iPhone. I had no luck selling the app. Downloads were higher in Japan, than the rest of the world.

Around year 2014 I had TriangleDraw version 2 ready. The canvas was much larger, and could be rotated by 60 degrees.
It worked on iPhone+iPad. I experimented with In-app-purchases, but I still had no luck earning any money on version 2.

Around year 2018/2019 I migrated all the TriangleDraw source code from ObjectiveC to Swift. The `UIDocumentBrowserViewController` is now being used, where in the past I used my own adhoc document browser. 
And best of all, it's free and open source. Please consider contributing to TriangleDraw.

- [Follow me on Twitter](https://twitter.com/neoneye)
- [Connect with me on LinkedIn](https://www.linkedin.com/in/simonstrandgaard/)

Thank you all for your generous support. 

This is Simon Strandgaard, developer of TriangleDraw, signing off.
