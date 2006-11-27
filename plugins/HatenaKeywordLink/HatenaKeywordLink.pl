# A plugin for setting "Hatena Diary Keyword" links to the entry body
#
# $Id$
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2006 Hirotaka Ogawa
#
package MT::Plugin::HatenaKeywordLink;
use strict;
use MT;
use base 'MT::Plugin';
use vars qw($VERSION);
$VERSION = '0.02';

my $plugin = __PACKAGE__->new({
    name => 'HatenaKeywordLink',
    description => 'This plugin enables MT to set "Hatena Diary Keyword" links to the entry body.',
    doc_link => 'http://code.as-is.net/wiki/HatenaKeywordLink_Plugin',
    author_name => 'Hirotaka Ogawa',
    author_link => 'http://profile.typekey.com/ogawa/',
    version => $VERSION,
    blog_config_template => 'config.tmpl',
    settings => new MT::PluginSettings([
	['hkl_presave_enable', { Default => 0 }],
    ]),
});
MT->add_plugin($plugin);

# global filter and container
MT::Template::Context->add_global_filter('hatena_keyword_link', \&flt_link);
MT::Template::Context->add_container_tag(HatenaKeywordLink => \&ctr_link);

# pre_save handler
MT->add_callback('MT::Entry::pre_save', 5, $plugin, \&pre_save_link);

use MT::ConfigMgr;
use MT::I18N qw(encode_text);
use XMLRPC::Lite;

sub flt_link {
    my ($str, $val, $ctx) = @_;
    return $str unless $str && $val;

    my $enc = MT::ConfigMgr->instance->PublishCharset;
    my $text = rpc_setKeywordLink(encode_text($str, $enc, 'utf-8'));
    return encode_text($text, 'utf-8', $enc) if $text;
    $str;
}

sub ctr_link {
    my ($ctx, $args, $cond) = @_;
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    defined(my $str = $builder->build($ctx, $tokens))
	or return $ctx->error($builder->errstr);

    my $enc = MT::ConfigMgr->instance->PublishCharset;
    my $text = rpc_setKeywordLink(encode_text($str, $enc, 'utf-8'));
    return encode_text($text, 'utf-8', $enc) if $text;
    $str;
}

sub pre_save_link {
    my ($eh, $obj, $orig) = @_;

    # check if 'body' and 'extended' are empty
    return unless $obj->text || $obj->text_more;

    # check if 'enabled' or not
    my $config = $plugin->get_config_hash('blog:' . $obj->blog_id) or return;
    return unless $config->{hkl_presave_enable};

    my $enc = MT::ConfigMgr->instance->PublishCharset;
    if ($obj->text) {
	my $text = rpc_setKeywordLink(encode_text($obj->text, $enc, 'utf-8'));
	$obj->text(encode_text($text, 'utf-8', $enc)) if $text;
    }
    if ($obj->text_more) {
	my $text = rpc_setKeywordLink(encode_text($obj->text_more, $enc, 'utf-8'));
	$obj->text_more(encode_text($text, 'utf-8', $enc)) if $text;
    }
}

our $rpc;
sub rpc_setKeywordLink {
    my ($text) = @_;
    unless ($rpc) {
	$rpc = XMLRPC::Lite->new;
	$rpc->proxy('http://d.hatena.ne.jp/xmlrpc');
    }
    my $res = $rpc->call('hatena.setKeywordLink', {
	body => XMLRPC::Data->type('string', $text),
	score => 20,
#	a_target => '_blank',
	a_class => 'keyword',
    });
    return if $res->fault;

    my $result = MT::I18N::utf8_off($res->result);
    $result =~ s/&lt;/</ig;
    $result =~ s/&gt;/>/ig;
    $result =~ s/&quot;/"/ig;
    $result;
}

1;
