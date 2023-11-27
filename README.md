The Cybercat blog website is based on the [Whiteglass](https://jekyllthemes.io/theme/whiteglass) theme.

## Workflow

Standard github workflow: 
- Create a branch
- Add your post
- Make a PR
- Wait for approval. 

The blog will be automatically rebuilt once your PR is merged.

### Previewing

Since the blog uses Jekyll, you will need to [install it](https://jekyllrb.com/docs/installation/) to be able to preview your contents. Once the installation is complete, just navigate to the repo folder and give `bundle exec jekyll serve`. Jekyll will spawn a local server (usually at `127.0.0.1:4000`) that will allow you to see the blog in locale.

## Usage

Posts must be placed in the `_posts` folder. Post titles follow the convention `yyyy-mm-dd-title.md`. Post assets (such as images) go in the folder `assetsPost`, where you should create a folder with the same name of the post.

Each post should start with the following preamble:
```yaml
---
layout: post
title: the title of your post
author: your name. Autor defaults to '20[ ] team' if left blank
categories: keyword or a list of keywords [keyword1, keyword2, keyword3]
excerpt: A short summary of your post
image: assetsPosts/yourPostFolder/imageToBeUsedAsThumbnails.png This is optional, but useful if e.g. you share the post on Twitter.
usemathjax: true (omit this line if you don't need to typeset math)
thanks: A short acknowledged message. It will be shown immediately above the content of your post.
---
```

As for the content of the post, it should be typeset in markdown.
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

## LaTeX-like theorem environments

We provide the following theorem environments: Definition, Proposition, Lemma, Theorem and Corollary. Numbering is automatic. If you need others, just ask. The way these works is as follows:
```html
<div class="definition" markdown="1">
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

</div>
```

This gets rendered as a shaded box with your content inside, prepended with a bold **Definition.**, as follows:
<div class="definition" markdown="1">
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

</div>

Numbering is automatic. Just swap `definition` inside the `class="..."` field above with `proposition`, `lemma`, `theorem` and `corollary` should you need those.

If you need to reference results, just add an `id="..."` field: 

```html
<div class="definition" markdown="1" id="myDefinition">
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

</div>
```

Then you can cite it as
```markdown
As we remarked in [Reference description](#myDefinition), we are awesome...
```
## Images

Whenever possible, we recommend the images to be `800` pixels in width, with **transparent** backround. Ideally, these should be easily readable on the light gray background of the blog website. You can deviate from these guidelines if you have no alternative, but our definition and your definition of 'I had no alternative' may be different, and *we may complain*.

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
