# building blair docs..

I am not entirely sure why I decided to use and spend hours on canada's government design style guides but well. (lets just say that canada has made publically available react packages for this..)

Whatever, anyways I wanted the site to load instantly. Achieved very easily..

1.  There should be minimal Javascript blocking the main thread. (86.48kb of js which i havent minified yet welp)
2.  It needs to score 100 on Lighthouse. (it did. not on mobile we got 93.)

I also wanted to find commands instantly.

I found search logic hard to reason about. I knew my command list was static. I wondered how I could filter it efficiently. I considered using Fuse.js (bad idea lol)

The way I think about this is simple.

1.  I have a list of commands.
2.  The user types "ping".
3.  I need to check the ID and the Name and the Aliases and the Description.

Framing the problem as "check every string field" was easier for me to think about than "implement a fuzzy search algorithm".

This gave me a new approach.

```tsx
// filter by search query
if (searchQuery.trim()) {
  const query = searchQuery.toLowerCase().trim();
  results = results.filter((cmd) => 
    cmd.trigger.toLowerCase().includes(query) ||
    cmd.id.toLowerCase().includes(query) ||
    cmd.description.toLowerCase().includes(query) ||
    (cmd.aliases && cmd.aliases.some(alias => alias.toLowerCase().includes(query)))
  );
}
```

Complex indexing was not necessary. It would increase complexity. The native `.filter()` method was good enough.

I think this is not always true and that some forms of indexing are faster, but I didn't have enough commands to care lol.

Also I wanted to support French (do not ask me why). This makes it needed that to display the UI consistently, a Context Provider seemed like a good approach.

 So I made a custom `LanguageContext`

```tsx
export const LanguageProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  // initialize state function to check url > storage > default
  const [language, setLanguageState] = useState<Language>(() => {
  });
}
```

This handles the URL parameters too. (ex: <https://blairdocs.pages.dev/?lang=fr>) so at any point you could easily send the site in french mode for whatever reason you may.

## wrapping up

Finally blair has a docs site with all commands in one place. i think it'll be best if I add guides, images, an actual landing page thats interesting, faq, etc here from here on out so loads of content can just be easily written here

Or is it? Well lets just say we do not serve markdown files for content so everything is literally written in manual typescript rn so some sort of framework may be needed for better dx..

Also site can definetly help with having a dark mode, its good for battery as well and all you discord dark mode glazers (i use dark mode)

Either way I am still curious whether there is a better way to handle the large text blocks without cluttering the DOM. I will do some more research there.

Thanks for reading! (btw this is the 67th line of this file, your welcome)
