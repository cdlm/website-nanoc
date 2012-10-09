---
title: Playing Tenuki
menu_title: Notes
header_title: Playing Tenuki
header_url: /notes
header_slogan: >
  The art of computer procrastinating:<br/>
  <em>random articles not completely unrelated
  to research, objects, programming, and craft.</em>
header_menu:
  - /
  - /notes/archives/
  - /notes/tags/
head:
  link:
    - {rel: alternate, type: application/atom+xml, href: /notes/feed.atom, title: Posts (Atom)}
    - {rel: alternate, type: application/rss+xml, href: /notes/feed.rss, title: Posts (RSS)}
---

# <%= @item[:title] %>

<% feed_named('/notes/feed/').entries.last(5).reverse.each do |post| %>
  <%= render 'article_summary', item: post %>
<% end %>


###### Why the name?
[Tenuki](http://senseis.xmp.net/?Tenuki) is a term from the [game of Go](http://senseis.xmp.net/?Go) that denotes ignoring the current local battle and just playing somewhere else.
While this is a professional website, I don't want to keep a strict editorial line about my research interests, or even about computer science in general; in fact, another title idea was *The Art of Computer Procrastinating*.
{: .banner}
