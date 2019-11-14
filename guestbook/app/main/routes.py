from flask import render_template, url_for, redirect
from app import db
from app.main.forms import PostForm
from app.models import Post
from app.main import bp

@bp.route('/', methods=['GET', 'POST'])
@bp.route('/index', methods=['GET', 'POST'])
def index():
    form = PostForm()
    if form.validate_on_submit():
        post = Post(body=form.post.data, author=form.author.data)
        db.session.add(post)
        db.session.commit()
        return redirect(url_for('main.index'))
    posts = Post.query.order_by(Post.timestamp.desc())
    return render_template('index.html', form=form, posts=posts)