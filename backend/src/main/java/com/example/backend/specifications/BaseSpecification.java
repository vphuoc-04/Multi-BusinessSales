package com.example.backend.specifications;

import jakarta.persistence.criteria.Predicate;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.jpa.domain.Specification;

public class BaseSpecification {
    public static <T> Specification<T> keywordSpec(String keyword, String... fields) {
        return (root, query, criteriaBuiler) -> {
            if (keyword == null || keyword.isEmpty()) {
                return criteriaBuiler.conjunction();
            } 
            Predicate[] predicates = new Predicate[fields.length];
            for(int i = 0; i < fields.length; i++) {
                predicates[i] = criteriaBuiler.like(
                    criteriaBuiler.lower(root.get(fields[i])), 
                    "%" + keyword.toLowerCase() + "%"
                );
            }
            return criteriaBuiler.or(predicates);
        };
    }

    public static <T> Specification<T> whereSpec(Map<String, String> filters) {
        return (root, query, criteriaBuiler) -> {
            List<Predicate> predicates = filters.entrySet().stream()
                .map(entry -> criteriaBuiler.equal(root.get(entry.getKey()), entry.getValue()))
                .collect(Collectors.toList());
            
            return criteriaBuiler.and(predicates.toArray(Predicate[]::new));
        };
    }

    public static <T> Specification<T> complexWhereSpec(Map<String, Map<String, String>> filters) {
        return (root, query, criteriaBuiler) -> {
            List<Predicate> predicates = filters.entrySet().stream()
                .flatMap((entry) -> entry.getValue().entrySet().stream()
                    .map(condition -> {
                        String field = entry.getKey();
                        String operator = condition.getKey();
                        String value = condition.getValue();

                        switch (operator.toLowerCase()) {
                            case "eq" -> {
                                return criteriaBuiler.equal(root.get(field), value); 
                            }
                            case "gt" -> {
                                return criteriaBuiler.greaterThan(root.get(field), value);
                            }
                            case "gte" -> {
                                return criteriaBuiler.greaterThanOrEqualTo(root.get(field), value);
                            }
                            case "lt" -> {
                                return criteriaBuiler.lessThan(root.get(field), value);
                            }
                            case "lte" -> {
                                return criteriaBuiler.lessThanOrEqualTo(root.get(field), value);
                            }
                            case "in" -> {
                                List<String> values = List.of(value.split(","));
                                return root.get(field).in(values);
                            }
                            default -> throw new IllegalArgumentException("Operator" + operator + "not supporte");             
                        }
                    }))
                .collect(Collectors.toList());
            return criteriaBuiler.and(predicates.toArray(Predicate[]::new));
        };
    }
}
