	</div>
	<!-- end content -->
	</div>
	<!-- end wrapper -->
	<!-- begin footer id="footer"  -->
	<div class="footer">
	
		<div class="footerin">
 
		<ul id="footerMenu">
                <li><a href="/designs">Design Central</a>  </li>
                <li><a href="/discussions">Discussion Lounge</a>  </li>
                <li><a href="/learnings">Learning Center</a>  </li>
                <!--<li><a href="/contest">Contest</a>  </li>-->
                <li><a href="/groups">Groups</a>  </li>
                <li><a href="/games">Games</a>  </li>
                <li><a href="/news">News</a>  </li>
                <li><a href="/blog">Blog</a>  </li>
                <li><a href="/events">Events</a>  </li>
	        <li><a href="/aboutus">About Us</a></li>
                <li><a href="/terms">Terms of Use</a></li>
                <li class="nobrd"><a href="/privacy">Privacy Policy</a></li>
		<!--<li>
                    <a href="<?php bloginfo('url'); ?>/">Home</a>
                </li>
                    <?php wp_list_pages('title_li=') ?>-->
		</ul>
		 
		</div>
	</div>
	<!-- end footer -->
</div>
<!-- end mainWrapper -->
<?php if (get_option('colorbold_analytics') <> "") { 
		echo stripslashes(stripslashes(get_option('colorbold_analytics'))); 
	} ?>
</body>
</html>

