import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

List<String> networkImages = [
  "https://images.pexels.com/photos/14517575/pexels-photo-14517575.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/20547958/pexels-photo-20547958/free-photo-of-blanco-y-negro-ciudad-arte-nueva-york.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/14517569/pexels-photo-14517569.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/14358785/pexels-photo-14358785.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/27586893/pexels-photo-27586893/free-photo-of-ciudad-carretera-trafico-calle.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/26937707/pexels-photo-26937707/free-photo-of-caballos-salvajes-del-lago-washoe.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/21033370/pexels-photo-21033370/free-photo-of-hombre-mujer-lago-en-pie.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27593122/pexels-photo-27593122/free-photo-of-mar-playa-agua-saludar.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/7704832/pexels-photo-7704832.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27531110/pexels-photo-27531110/free-photo-of-comida-amanecer-cafeina-cafe.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
  "https://images.pexels.com/photos/27662758/pexels-photo-27662758/free-photo-of-pan-comida-oscuro-cena.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27662742/pexels-photo-27662742/free-photo-of-comida-cena-almuerzo-hoja.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27662697/pexels-photo-27662697/free-photo-of-alcohol-barra-bar-beber.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27669788/pexels-photo-27669788/free-photo-of-amanecer-puesta-de-sol-hombre-gente.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/14517574/pexels-photo-14517574.jpeg?auto=compress&cs=tinysrgb&w=800"
      "https://images.pexels.com/photos/14517575/pexels-photo-14517575.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/20547958/pexels-photo-20547958/free-photo-of-blanco-y-negro-ciudad-arte-nueva-york.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/14517569/pexels-photo-14517569.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/14358785/pexels-photo-14358785.jpeg?auto=compress&cs=tinysrgb&w=800",
  "https://images.pexels.com/photos/27586893/pexels-photo-27586893/free-photo-of-ciudad-carretera-trafico-calle.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/26937707/pexels-photo-26937707/free-photo-of-caballos-salvajes-del-lago-washoe.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/21033370/pexels-photo-21033370/free-photo-of-hombre-mujer-lago-en-pie.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27593122/pexels-photo-27593122/free-photo-of-mar-playa-agua-saludar.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/7704832/pexels-photo-7704832.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27531110/pexels-photo-27531110/free-photo-of-comida-amanecer-cafeina-cafe.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
  "https://images.pexels.com/photos/27662758/pexels-photo-27662758/free-photo-of-pan-comida-oscuro-cena.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27662742/pexels-photo-27662742/free-photo-of-comida-cena-almuerzo-hoja.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27662697/pexels-photo-27662697/free-photo-of-alcohol-barra-bar-beber.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
  "https://images.pexels.com/photos/27669788/pexels-photo-27669788/free-photo-of-amanecer-puesta-de-sol-hombre-gente.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load"
];

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: SizedBox(
        width: 500,
        height: 200,
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: 600,
              child: TextFormField(
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                    label: Text("Search"), suffixIcon: Icon(Icons.search)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: MasonryGridView.count(
                    itemCount: networkImages.length,
                    crossAxisCount: 3,
                    addAutomaticKeepAlives: true,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return Image.network(
                        networkImages[index],
                        scale: 2,
                        fit: BoxFit.fitWidth,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
