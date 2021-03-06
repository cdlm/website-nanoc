---
title: A better Qwerty layout for accents
created_at: 2010-04-17
image: /notes/images/keyboard/
tags: [usability, hack, esperanto]
---
<% excerpt :summary do %>
Like many programmers whose main language is not English, I've been facing the keyboard dilemma for a while:
keep my native layout even though frequent programming characters like `[]{}|\` require 2 or 3 fingers, or adopt the standard US Qwerty layout?

In practice, I've chosen Qwerty because I write a lot in English anyway, and its advantages outweight the couple of defaults and inconsistencies it does have. The problem is, I've recently started learning [Esperanto][], which requires a dozen diacritics that are not reachable on the basic Qwerty.

So, I made a [layout][] to fix that, plus a couple itches I had with the basic Qwerty layout.

[esperanto]: http://en.wikipedia.org/wiki/Esperanto
[layout]: http://github.com/cdlm/infrastructure/blob/master/mac/Accented%20QWERTY.keylayout
<% end %>


## Rollover & Overstriking

The problem with accessing diacritics in Qwerty is that the dead-key combinations have not been designed with rollover or overstriking in mind, as described by Jef Raskin in [_The Humane Interface_][thi]:

Rollover
: A keyboard that supports rollover does not get confused when you start pressing a key before the previous one has been completely released. This is very useful for sequences of letters that are typed in a single swipe, like the _-ion_ suffix.

Overstriking
: Overstriking is when key B is pressed after, but released before key A; it's important that the last key pressed is released first, else this is rollover. Raskin proposed that characters could be composed this way by temporally overstriking keys, like one would physically overstrike glyphs on a typewriter.

What makes accents painful with Qwerty it that they require finger-jumping, for instance to get "É":
press option, press e, release *both*, press shift, press e, release.
Admittedly, you get used to it, but the gesture would flow better if it was just:
press shift and option, double-type e, release.

Actually, most of the problem was that the layout defines nothing when it's in a dead-key mode and the option key has not been released. I just duplicated accented letters to these option-keys. Similarly, to handle accented capitals, I duplicated the dead-keys to their shift-option equivalents.

## Why keep Qwerty, what about alternate keyboards?

The basic Qwerty layout has many advantages:

- it is well-known —in fact, most of my coworkers, french or not, use it already;
- it's the default with exotic hardware or system operation modes;
- it conveniently groups most open-close character pairs.

Mac OS does have an _U.S. Extended_ keyboard layout that provides more accented characters, but it has the same rollover problems, and the dead-keys are placed completely differently, invalidating muscular memory learned from the usual Qwerty.

Of course, there is also the solution of an entirely new keyboard layout such as [Bépo][bepo], which has been designed from the ground up to fix all these problems; I might adopt it sometime, but this is too big a step for me for now. I learned [Dvorak][] because it was only a quick [keycap permutation][qw-dv] away from Qwerty; I can't touch-type, so converting my physical keyboard is necessary, but that also frustrates anyone I lend my keyboard to.

## The layout

[Download the file here][layout], then drop it into your `Library/Keyboard Layouts` directory; it should then become available from the _Language & Text_ preference pane. I made it using [Ukelele][], and am releasing it under the [Creative Commons Attribution-Share Alike 3.0 License][cc-bysa].

### What's changed

- The accent dead keys still work the same, but now also work with overlaps of shift, option, and the accented letter.
- The circumflex will work with the [Esperanto][] consonants Ĉĉ, Ĝĝ, Ĥĥ, Ĵĵ, Ŝŝ.
- The [breve][] for Ŭŭ is assigned to option-b.
- I moved some signs and greek letters around: ∆ is shift-option-d, λ is option-l, æ is option-a… this is subject to taste and future changes, so I won't list them all precisely, but suggestions are welcome.

### What's still needed

- An icon. I'm thinking probably a grey one like the Dvorak layout.
- More accents, or extended characters? Tell me which…


[azerty]: http://en.wikipedia.org/wiki/AZERTY#Layout_of_the_French_keyboard_under_Macintosh
[bepo]: http://bepo.fr
[breve]: http://en.wikipedia.org/wiki/Breve
[cc-bysa]: http://creativecommons.org/licenses/by-sa/3.0/
[dvorak]: http://en.wikipedia.org/wiki/Dvorak_Simplified_Keyboard
[qw-dv]: http://www.flickr.com/photos/damienpollet/4302582401
[thi]: http://en.wikipedia.org/wiki/The_Humane_Interface
[ukelele]: http://scripts.sil.org/ukelele
