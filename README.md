# README <!-- omit in toc -->

The Cybercat blog website is based on the [Whiteglass](https://jekyllthemes.io/theme/whiteglass) theme.

## TOC <!-- omit in toc -->

- [Workflow](#workflow)
  - [Previewing](#previewing)
- [Post preamble](#post-preamble)
- [Latex](#latex)
  - [Theorem environments](#theorem-environments)
    - [Referencing](#referencing)
  - [Typesetting diagrams](#typesetting-diagrams)
    - [Quiver](#quiver)
    - [Tikz](#tikz)
    - [Referencing](#referencing-1)
- [Images](#images)
    - [Referencing](#referencing-2)
- [Code](#code)


## Workflow

Standard github workflow: 
- Clone this repo
- Create a branch
- Write your post
- Make a PR
- Wait for approval
 
The blog will be automatically rebuilt once your PR is merged.

### Previewing

Since the blog uses Jekyll, you will need to [install it](https://jekyllrb.com/docs/installation/) or use the included nix flake devshell (just run `nix develop` with flakes-enabled nix installed) to be able to preview your contents. Once the installation is complete, just navigate to the repo folder and give `bundle exec jekyll serve`. Jekyll will spawn a local server (usually at `127.0.0.1:4000`) that will allow you to see the blog in locale.

## Post preamble

Posts must be placed in the `_posts` folder. Post titles follow the convention `yyyy-mm-dd-title.md`. Post assets (such as images) go in the folder `assetsPost`, where you should create a folder with the same name of the post.

Each post should start with the following preamble:
```yaml
---
layout: post
title: the title of your post
author: your name
categories: keyword or a list of keywords [keyword1, keyword2, keyword3]
excerpt: A short summary of your post
image: assetsPosts/yourPostFolder/imageToBeUsedAsThumbnails.png This is optional, but useful if e.g. you share the post on Twitter.
usemathjax: true (omit this line if you don't need to typeset math)
thanks: A short acknowledged message. It will be shown immediately above the content of your post.
---
```

As for the content of the post, it should be typeset in markdown.

## Latex

- Inline math is shown by using `$ ... $`. Notice that some expressions such as `a_b` typeset correctly, while expressions like `a_{b}` or `a_\command` sometimes do not. I guess this is because mathjax expects `_` to be followed by a literal.
- Display math is shown by using `$$ ... $$`. The problem above doesn't show up in this case, but you gotta be careful:
    ```markdown
    text
    $$ ... $$
    text
    ```
    does not typeset correctly, whereas:
    ```markdown
    text

    $$
    ...
    $$

    text
    ```
    does. You can also use environments, as in:
    ```
    $$
    \begin{align*}
     ...
    \end{align*}
    $$
    ```

### Theorem environments

We provide the following theorem environments: Definition, Proposition, Lemma, Theorem and Corollary. Numbering is automatic. If you need others, just ask. The way these works is as follows:
```latex
{% def %}
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

{% enddef %}
```

This gets rendered as a shaded box with your content inside, prepended with a bold **Definition.**. Numbering is automatic. 

Use the tags:

```latex
{% def %}
    For your definitions
{% enddef %}

{% not %}
    For your notations
{% endnot %}

{% ex %}
    For your examples
{% endex %}

{% diag %}
    For your diagrams
{% enddiag %}

{% prop %}
    For your propositions
{% endprop %}

{% lem %}
    For your lemmas
{% endlem %}

{% thm %}
    For your theorems
{% endthm %}

{% cor %}
    For your corollaries
{% endcor %}
```

#### Referencing

If you need to reference results just append a `{"id":"your_reference_tag"}` after the tag, where `your_reference_tag` is the same as a LaTex label. Fore example:


```latex
{% def {"id":"your_reference_tag"} %}
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$
{% enddef %}
```

Then you can reference this by doing:

```markdown
As we remarked in [Reference description](#your_reference_tag), we are awesome...
```

### Typesetting diagrams

We support two types of diagrams: quiver and TikZ.

#### Quiver

You can render [quiver](https://q.uiver.app/) diagrams by enclosing quiver expoted iframes between `quiver` tags: 
- On [quiver](https://q.uiver.app/), click on `Export: Embed code`
- Copy the code
- In the blog, put it between delimiters as follows:

```html
{% quiver %}
<!-- https://q.uiver.app/codecodecode-->
<iframe codecodecode></iframe>
{% endquiver %}
```

**Please deselect `fixed size` when exporting the quiver diagram.**

#### Tikz

You can render tikz diagrams by enclosing tikz code between `tikz` tags, as follows:

```latex
{% tikz %}
  \begin{tikzpicture}
    \draw (0,0) circle (1in);
  \end{tikzpicture}
{% endtikz %}
```

Notice that at the moment tikz rendering:
- Supports any option you put after `\begin{document}` in a `.tex` file. So you can use this to include any stuff you'd typeset with LaTex (but we STRONGLY advise against it).
- Does not support usage of anything that should go in the LaTex preamble, that is, before `\begin{document}`. This includes exernal tikz libraries such as `calc`, `arrows`, etc; and packages such as `tikz-cd`. Should you need `tikz-cd`, use quiver as explained above. If you need fancier stuff, you'll have to render the tikz diagrams by yourself and import them as images (see below).

#### Referencing

Referencing works also for the quiver and tikz tags, as in:

```latex
{% tikz {"id":"your_reference_tag"} %}
...
{% endtikz %}
```

This automatically creates a numbered 'Figure' caption under the figure.

Whenever possible, we encourage you to enclose diagrams into definitions/propositions/etc should you need to reference them.

## Images

Images are included via standard markdown syntax:

```markdown
![image description](image_path)
```

`image_path` can be a remote link. Should you need to upload images to this blog post, do as follows:

- Create a folder in `assetsPosts` with the same title of the blog post file. So if the blogpost file is `yyyy-mm-dd-title.md`, create the folder `assetsPosts/yyyy-mm-dd-title`
- Place your images there
- Reference the images by doing:
    ```markdown
    ![image description](../assetsPosts/yyyy-mm-dd-title/image)
    ```

Whenever possible, we recommend the images to be in the format `.png`, and to be `800` pixels in width, with **transparent** backround. Ideally, these should be easily readable on the light gray background of the blog website. You can strive from these guidelines if you have no alternative, but our definition and your definition of 'I had no alternative' may be different, and *we may complain*.

#### Referencing

Referencing works exactly as for diagrams:

```latex
{% figure {"id":"your_reference_tag"} %}
  ![image description](image_path)
{% endfigure %}
```

## Code

CyberCat blog offers support for code snippets:

```ruby
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
```

To include a code snippet, just give:

~~~markdown
```language the snippet is written in
your code
```
~~~

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
