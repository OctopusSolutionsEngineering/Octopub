package com.octopus.products.infrastructure.utilities;

import jakarta.persistence.EntityManager;
import jakarta.persistence.criteria.*;

import java.util.Set;


public class JpaUtils {

    public static <E, D> long count(final EntityManager entityManager,
                                    final CriteriaBuilder cb,
                                    final CriteriaQuery<D> criteria,
                                    final Root<E> root) {
        CriteriaQuery<Long> query = createCountQuery(cb, criteria, root, root.getModel().getJavaType());
        return entityManager.createQuery(query).getSingleResult();
    }

    private static <T, D> CriteriaQuery<Long> createCountQuery(final CriteriaBuilder cb,
                                                               final CriteriaQuery<D> criteria,
                                                               final Root<T> root,
                                                               final Class<T> entityClass) {

        final CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
        final Root<T> countRoot = countQuery.from(entityClass);

        doJoins(root.getJoins(), countRoot);
        doJoinsOnFetches(root.getFetches(), countRoot);

        countQuery.select(cb.count(countRoot));
        countQuery.where(criteria.getRestriction());

        countRoot.alias(root.getAlias());

        return countQuery.distinct(criteria.isDistinct());
    }

    @SuppressWarnings("unchecked")
    private static void doJoinsOnFetches(Set<? extends Fetch<?, ?>> joins, Root<?> root) {
        doJoins((Set<? extends Join<?, ?>>) joins, root);
    }

    private static void doJoins(Set<? extends Join<?, ?>> joins, Root<?> root) {
        for (Join<?, ?> join : joins) {
            Join<?, ?> joined = root.join(join.getAttribute().getName(), join.getJoinType());
            joined.alias(join.getAlias());
            doJoins(join.getJoins(), joined);
        }
    }

    private static void doJoins(Set<? extends Join<?, ?>> joins, Join<?, ?> root) {
        for (Join<?, ?> join : joins) {
            Join<?, ?> joined = root.join(join.getAttribute().getName(), join.getJoinType());
            joined.alias(join.getAlias());
            doJoins(join.getJoins(), joined);
        }
    }
}