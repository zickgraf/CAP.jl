derivation:
  - ProjectionInFactorOfDirectSum
  - function:
      parameters: [ "cat", "diagram", "projection_number" ]
      bindings:
        morphisms:
          List:
            - Range:
                - 1
                - Length: [ list ]
            - function:
                parameters: [ "i" ]
                bindings:
                  return:
                    if:
                      - "=": [ i, projection_number ]
                      - IdentityMorphism:
                          - cat
                          - "[]": [ list, projection_number ]
                      - true
                      - ZeroMorphism:
                          - cat
                          - "[]": [ list, i ]
                          - "[]": [ list, projection_number ]
        return:
          UniversalMorphismFromDirectSum:
            - cat
            - list
            - "[]": [ list, projection_number ]
            - morphisms
