
<!-- begin search box -->
		<div id="searchBox" class="clearfix">
			<form id="searchform" action="" method="get">
				<input id="s" type="text" name="s" value=""/>
				<input id="searchsubmit" type="submit" value="SEARCH"/>
			</form>
		</div>
		<!-- end search box -->
		<!-- begin adsBox -->
		<?php if(get_option('colorbold_ads')=='yes'){?>
			<div id="ads" class="clearfix">
			<?php do_action('ad-minister', array('position' => 'Sidebar', 'limit' => 6)); ?>	
			</div>	
		<?php }?>
		<!-- end adsBox -->
		
		<!-- begin twitter box -->
		<?php if(get_option('colorbold_twitter_link')!=''){?>
		
		<div id="twitter">
			<a href="<?php echo get_option('colorbold_twitter_link');?>" title="Follow us on Twitter!"><img src="<?php bloginfo('template_url'); ?>/images/ico_twitter.png" alt="Follow us on Twitter!" /></a>
			<span>Follow us on Twitter!</span><br /><?php echo get_option('colorbold_twitter_txt');?>
		</div>
		<?php }?>
		<!-- end twitter box -->
		
		<?php 
	/* Widgetized sidebar */
	if ( !function_exists('dynamic_sidebar') || !dynamic_sidebar() ) : ?><?php endif; ?>
		<?php if(get_option('colorbold_flickr')=='yes'){?>
		
		<div id="flickr">
			<div class="flickr_tit"><img src="<?php bloginfo('template_url'); ?>/images/flickr_logo.jpg" alt="Flickr Photostream"  /></div>
			<?php get_flickrRSS(); ?> 
		</div>
		<?php }?>

