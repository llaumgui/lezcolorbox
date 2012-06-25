{*
Input:
 image_class - Which image alias to show, default is large
 css_class     - Optional css class to wrap around the <img> tag, the
                 class will be placed in a <div> tag.
 alignment     - How to align the image, use 'left', 'right' or false().
 link_to_image - boolean, if true the url_alias will be fetched and
                 used as link.
 href          - Optional string, if set it will create a <a> tag
                 around the image with href as the link.
 border_size   - Size of border around image, default is 0
*}
{default image_class=large
         css_class=false()
         alignment=false()
         link_to_image=false()
         href=false()
         target=false()
         hspace=false()
         border_size=0
         border_color=''
         border_style=''
         margin_size=''
         alt_text=''
         title=''
         link_class=''
         use_colorbox=true()}

{def $image_content = $attribute.content
     $colorbox_script = 'jquery.colorbox.js'
     $linked_image_class = ezini( 'ColorboxSettings', 'LinkedImageClass', 'lezcolorbox.ini' )
}
{if $image_content.is_valid}

    {def $image        = $image_content[$image_class]
         $inline_style = ''}

    {* Disable ColorBox *}
    {if $href}
        {set $use_colorbox = false()}
    {/if}

    {* Enable $link_to_image *}
    {if and( $href|not(), $use_colorbox, $image_class|ne($linked_image_class) ) }
        {set $link_to_image = true()}
    {/if}

    {if $link_to_image}
        {set $href = $image_content['original'].url|ezroot}
    {/if}

    {* Enable ColorBox *}
    {if $use_colorbox}
        {set $link_class = $link_class|append( ' colorbox' )}
        {run-once}
        {if ezini( 'ColorboxSettings', 'UseMinified', 'lezcolorbox.ini' )|eq('enabled')}
            {set $colorbox_script = 'jquery.colorbox-min.js'}
        {/if}
        {ezscript_require( array('ezjsc::jquery', $colorbox_script) )}
        {ezcss_require( array( concat( 'colorbox/', ezini( 'ColorboxSettings', 'Design', 'lezcolorbox.ini' ), '.css' ) ) )}
<script type="text/javascript">
$(document).ready(function(){ldelim}$("a.colorbox").colorbox({ldelim}
    current:'{'image current of total'|i18n('design/standard/colorbox')}',
    previous:'{'previous'|i18n('design/standard/colorbox')}',
    next:'{'next'|i18n('design/standard/colorbox')}',
    close:'{'close'|i18n('design/standard/colorbox')}'
{rdelim});{rdelim});
</script>
        {/run-once}
    {/if}


    {switch match=$alignment}
    {case match='left'}
        <div class="imageleft">
    {/case}
    {case match='right'}
        <div class="imageright">
    {/case}
    {case/}
    {/switch}

    {if $css_class}
        <div class="{$css_class|wash}">
    {/if}

    {if and( is_set( $image ), $image )}
        {if $alt_text|not}
            {if $image.text}
                {set $alt_text = $image.text}
            {else}
                {set $alt_text = $attribute.object.name}
            {/if}
        {/if}
        {if $title|not}
            {set $title = $alt_text}
        {/if}
        {if $border_size|trim|ne('')}
            {set $inline_style = concat( $inline_style, 'border: ', $border_size, 'px ', $border_style, ' ', $border_color, ';' )}
        {/if}
        {if $margin_size|trim|ne('')}
            {set $inline_style = concat( $inline_style, 'margin: ', $margin_size, 'px;' )}
        {/if}
        {if $href}<a href={$href}{if and( is_set( $link_class ), $link_class )} class="{$link_class}"{/if}{if and( is_set( $link_id ), $link_id )} id="{$link_id}"{/if}{if $target} target="{$target}"{/if}{if and( is_set( $link_title ), $link_title )} title="{$link_title|wash}"{/if}>{/if}
        <img src={$image.url|ezroot} width="{$image.width}" height="{$image.height}" {if $hspace}hspace="{$hspace}"{/if} style="{$inline_style}" alt="{$alt_text|wash(xhtml)}" title="{$title|wash(xhtml)}" />
        {if $href}</a>{/if}
    {/if}

    {if $css_class}
        </div>
    {/if}

    {switch match=$alignment}
    {case match='left'}
        </div>
    {/case}
    {case match='right'}
        </div>
    {/case}
    {case/}
    {/switch}

    {undef $image $inline_style}

{/if}

{undef $image_content}

{/default}
