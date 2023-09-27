package com.mooc.backend.specs;

import com.mooc.backend.entities.PageLayout;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
public class PageLayoutSpec implements Specification<PageLayout> {
    private final PageLayoutFilter filter;
    @Override
    public Predicate toPredicate(
            @NonNull Root<PageLayout> root,
            @NonNull CriteriaQuery<?> query,
            @NonNull CriteriaBuilder builder) {
        // root: 代表查询的实体类
        // query: 查询语句
        // builder: 构造查询条件的工具
        List<Predicate> predicates = new ArrayList<>();
        if (filter.title() != null) {
            // 相当于 SQL 中的 title like '%xxx%'
            predicates.add(builder.like(builder.lower(root.get("title")), "%" + filter.title().toLowerCase() + "%"));
        }
        if (filter.platform() != null) {
            // 相当于 SQL 中的 platform = xxx
            predicates.add(builder.equal(root.get("platform"), filter.platform()));
        }
        if (filter.status() != null) {
            // 相当于 SQL 中的 status = xxx
            predicates.add(builder.equal(root.get("status"), filter.status()));
        }
        if (filter.pageType() != null) {
            // 相当于 SQL 中的 page_type = xxx
            predicates.add(builder.equal(root.get("pageType"), filter.pageType()));
        }
        if (filter.startTimeFrom() != null) {
            // 相当于 SQL 中的 start_time >= xxx
            predicates.add(builder.greaterThanOrEqualTo(root.get("startTime"), filter.startTimeFrom()));
        }
        if (filter.startTimeTo() != null) {
            // 相当于 SQL 中的 start_time <= xxx
            predicates.add(builder.lessThanOrEqualTo(root.get("startTime"), filter.startTimeTo()));
        }
        if (filter.endTimeFrom() != null) {
            // 相当于 SQL 中的 end_time >= xxx
            predicates.add(builder.greaterThanOrEqualTo(root.get("endTime"), filter.endTimeFrom()));
        }
        if (filter.endTimeTo() != null) {
            // 相当于 SQL 中的 end_time <= xxx
            predicates.add(builder.lessThanOrEqualTo(root.get("endTime"), filter.endTimeTo()));
        }
        return query.where(builder.and(predicates.toArray(new Predicate[0])))
                .orderBy(builder.desc(root.get("id")))
                .getRestriction();
    }
}
