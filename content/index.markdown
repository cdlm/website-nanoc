---
title: Home
menu_title: About me
---
<%= render 'partials/markdown_links' %>
[![Logo USTL](/images/ustl-128.jpg){: .noframe}][ustl]
[![Logo Telecom](/images/telecom-128.png){: .noframe}][telecom]
[![Logo Inria](/images/inria-128.png){: .noframe}][inria]
[![Pharo by Example cover](/images/pbe-128.jpg){: .framed}][pbe]
{: .right}

<% render "slidesjs/slideshow_bare", :style => 'width:128px;height:128px;', :class => 'left noframe' do %>
  <% items_by_identifier(%r{/images/faces/.*}).each do |i| %>
    <img class='slide' src="<%= relative_path_to i %>" title="<%= i[:title] %>" alt="Random portrait" width="128"/>
  <% end %>
<% end %>

I am assistant professor (*Maître de conférences*) at the [university of Lille 1][ustl] ([UFR IEEA][ieea]) since september 2008.

I [teach](/teaching/) programming and software engineering at [Telecom Lille 1][telecom],
and [research](/research/) on reengineering at [Inria][] within the [RMoD project-team][rmod].

I'm a co-author of the open-source books [*Squeak by Example*][sbe] and [*Pharo by Example*][pbe].

##### Curriculum
I received an engineering degree in computer science from [Insa][] in 2001, and obtained my Ph.D in 2005 from the [university of Rennes 1][rennes1], France ([details here](curriculum.html)).

[ieea]: http://ieea.univ-lille1.fr "Unité de Formation et de Recherche d’Informatique, Électronique, Électrotechnique et Automatique"
[insa]: http://www.insa-rennes.fr/?LangueID=2 "Institut National des Sciences Appliquées"
[rennes1]: http://www.univ-rennes1.fr/english/

----

<%#
{ticker:: {path: news.html, more: Older news…}}
## News
{ticker}

{ticker:: {path: news.html, number: ~, period: :upcoming}}
## Upcoming
{ticker}
%>

###### Software evolves!
Therefore, these pages are never complete, and always under constant refactoring and evolution… for some definition of *constant*.
{: .banner}


## [Contact Info](contact.html)

See my [detailed contact page](contact.html) for more info, the [access map](contact.html#map) to our offices, and my [agenda](contact.html#agenda).

<%= render 'partials/contact_info' %>

