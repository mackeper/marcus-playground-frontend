<script lang="ts">
	export const prerender = true;
</script>

<div class="container">
	<nav class="desktop-navbar">
		<ul><li>Real Money Company</li></ul>
		<ul>
			<li><a href="/">Home</a></li>
			<li><a href="/usernamegenerator">Username Generator</a></li>
			<li role="list" dir="rtl">
				<a href="#_" aria-haspopup="listbox">Games</a>
				<ul role="listbox ">
					<li><a href="/games/cs">CS</a></li>
					<li><a href="/games/idleon">Idleon</a></li>
				</ul>
			</li>
			<li role="list" dir="rtl">
				<a href="#_" aria-haspopup="listbox">Dev</a>
				<ul role="listbox "><li><a href="/dev/tools">Tools</a></li></ul>
			</li>
			<li role="list" dir="rtl">
				<a href="#_" aria-haspopup="listbox">Blog</a>
				<ul role="listbox ">
					<li><a href="/blog">Blog</a></li>
					<li><a href="/blog/new">New Entry</a></li>
				</ul>
			</li>
			<li><a href="/diet">Diet</a></li>
			<li><a href="/tracker">Tracker</a></li>
			<li><a href="/boardgames">Boardgames</a></li>
			<li><a href="/about">About</a></li>
		</ul>
	</nav>
	<slot />
</div>
