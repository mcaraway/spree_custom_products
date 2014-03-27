insert into spree_custom_products (name, permalink, description, public, final, step, user_id, created_at, updated_at) select sp.name, sp.permalink, sp.description, sp.public, sp.final, case sp.final when true then 'finalize' else 'add_name' end as step, sp.user_id, now(), now() from spree_products sp where sp.user_id is not null;

update spree_custom_products set flavor_1_name = subquery.value from (select sp.permalink, spp.value as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor1name') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_2_name = subquery.value from (select sp.permalink, spp.value as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor2name') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_3_name = subquery.value from (select sp.permalink, spp.value as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor3name') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_1_sku = subquery.value from (select sp.permalink, spp.value as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor1sku') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_2_sku = subquery.value from (select sp.permalink, spp.value as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor2sku') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_3_sku = subquery.value from (select sp.permalink, spp.value as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor3sku') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_1_percentage = subquery.value from (select sp.permalink, cast(spp.value as INTEGER) as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor1percent') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_2_percentage = subquery.value from (select sp.permalink, cast(spp.value as INTEGER) as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor2percent') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products set flavor_3_percentage = subquery.value from (select sp.permalink, cast(spp.value as INTEGER) as value from spree_products sp join spree_product_properties spp on sp.id = spp.product_id join spree_properties spr on spp.property_id = spr.id where sp.user_id is not null and spr.name = 'flavor3percent') as subquery where spree_custom_products.permalink = subquery.permalink;
update spree_custom_products 
set 
	sweetness = sub.sweetness,
	strength = sub.strength,
	fruity = sub.fruity,
	nutty = sub.nutty,
	vegetal = sub.vegetal,
	woody = sub.woody,
	aroma = sub.aroma,
	spicy = sub.spicy,
	floral = sub.floral
from (
	select 
		sp1.permalink,
		(round(avg(flavors.sweetness)*2))/2 as sweetness,
		(round(avg(flavors.strength)*2))/2 as strength,
		(round(avg(flavors.fruity)*2))/2 as fruity,
		(round(avg(flavors.nutty)*2))/2 as nutty,
		(round(avg(flavors.vegetal)*2))/2 as vegetal,
		(round(avg(flavors.woody)*2))/2 as woody,
		(round(avg(flavors.aroma)*2))/2 as aroma,
		(round(avg(flavors.spicy)*2))/2 as spicy,
		(round(avg(flavors.floral)*2))/2 as floral
	from spree_products sp1
	left outer join spree_product_properties spp11 on sp1.id = spp11.product_id and spp11.property_id = (select id from spree_properties where name = 'flavor1sku')
	left outer join spree_product_properties spp12 on sp1.id = spp12.product_id and spp12.property_id = (select id from spree_properties where name = 'flavor2sku')
	left outer join spree_product_properties spp13 on sp1.id = spp13.product_id and spp13.property_id = (select id from spree_properties where name = 'flavor3sku')
	left outer join (
		select 
			sv.sku, 
			cast(spp1.value as integer) as sweetness,
			cast(spp2.value as integer) as strength,
			cast(spp3.value as integer) as fruity,
			cast(spp4.value as integer) as nutty,
			cast(spp5.value as integer) as vegetal,
			cast(spp6.value as integer) as woody,
			cast(spp7.value as integer) as aroma,
			cast(spp8.value as integer) as spicy,
			cast(spp9.value as integer) as floral
		from spree_products sp 
		join spree_variants sv on sp.id = sv.product_id
		left outer join spree_product_properties spp1 on sp.id = spp1.product_id and spp1.property_id = (select id from spree_properties where name = 'Sweetness')
		left outer join spree_product_properties spp2 on sp.id = spp2.product_id and spp2.property_id = (select id from spree_properties where name = 'Strength')
		left outer join spree_product_properties spp3 on sp.id = spp3.product_id and spp3.property_id = (select id from spree_properties where name = 'Fruity')
		left outer join spree_product_properties spp4 on sp.id = spp4.product_id and spp4.property_id = (select id from spree_properties where name = 'Nutty')
		left outer join spree_product_properties spp5 on sp.id = spp5.product_id and spp5.property_id = (select id from spree_properties where name = 'Vegetal')
		left outer join spree_product_properties spp6 on sp.id = spp6.product_id and spp6.property_id = (select id from spree_properties where name = 'Woody')
		left outer join spree_product_properties spp7 on sp.id = spp7.product_id and spp7.property_id = (select id from spree_properties where name = 'Aroma')
		left outer join spree_product_properties spp8 on sp.id = spp8.product_id and spp8.property_id = (select id from spree_properties where name = 'Spicy')
		left outer join spree_product_properties spp9 on sp.id = spp9.product_id and spp9.property_id = (select id from spree_properties where name = 'Floral')
		join spree_blendable_products_taxons sbpt on sbpt.product_id = sp.id) flavors on flavors.sku = spp11.value or flavors.sku = spp12.value or flavors.sku = spp13.value
	where sp1.user_id is not null
	group by sp1.permalink) as sub
where sub.permalink = spree_custom_products.permalink;