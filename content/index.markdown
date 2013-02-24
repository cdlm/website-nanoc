---
title: Home
menu_title: About me
---
<%= render 'partials/markdown_links' %>
<% render "slidesjs/slideshow_bare", style: 'width:128px;height:128px;', css_class: 'left noframe' do %>
  <% items_by_identifier(%r{/images/faces/.*}).each do |i| %>
    <img class='slide' src="<%= relative_path_to i %>" title="<%= i[:title] %>" alt="Random portrait" width="128"/>
  <% end %>
<% end %>

[![Logo Inria](/images/inria-128.png){: .noframe}][inria]
{: .right}

[![Logo USTL](/images/ustl-128.jpg){: .noframe}][ustl]
{: .right}

[![Logo Telecom](/images/telecom-128.png){: .noframe}][telecom]
{: .right}

[![Pharo by Example cover](/images/pbe-128.jpg){: .framed}][pbe]
{: .right}

I am associate professor (*Maître de conférences*) at the [university of Lille 1][ustl] ([UFR IEEA][ieea]) since september 2008.

I [teach](/teaching/) programming and software engineering at [Telecom Lille 1][telecom],
and [research](/research/) on reengineering at [Inria][] within the [RMoD project-team][rmod].

I'm a co-author of the open-source books [*Squeak by Example*][sbe] and [*Pharo by Example*][pbe].

##### Curriculum
I received an engineering degree in computer science from [Insa][] in 2001, and obtained my Ph.D in 2005 from the [university of Rennes 1][rennes1], France ([details here](/curriculum/)).

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


## [Contact Info](/contact/)

See my [detailed contact page](/contact/) for more info, the [access map](/contact/#map) to our offices, and my [agenda](/contact/#agenda).

<%= render 'partials/contact_info' %>

<div class="banner">
  <h6>Software evolves!</h6>
  <p>Therefore, these pages are never complete, and always under constant refactoring and evolution… for some definition of <em>constant</em>.</p>
</div>

