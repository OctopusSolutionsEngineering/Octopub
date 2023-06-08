package com.octopus.products.infrastructure.utilities;

import com.octopus.products.domain.entities.Product;
import jakarta.persistence.Tuple;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.From;
import jakarta.persistence.criteria.Root;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueryRootTuple<T> {
    private CriteriaQuery<T> query;
    private Root<Product> root;
}
